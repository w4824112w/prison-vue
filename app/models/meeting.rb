#encoding = utf-8

class Meeting < ApplicationRecord
  belongs_to :family
  belongs_to :terminal

  validates :family_id, :application_date, :presence => true, on: :create
  
  # A family member can only meet once a day
  validates :family_id, uniqueness: { scope: :application_date, message: '该日申请已经批准，请勿重复申请' },
            unless: Proc.new { Meeting.where(family: family_id, status: 'PASSED', application_date: application_date).empty? },
            on: :create

  # Can not submit an application again if there is another application
  # which status is `PENDING` that was submitted by the same family
  validate :pending?, on: :create

  validate :number_limit?, on: :create

  validate :balance_insufficient?, on: :create

  validate :date_validation?, on: :create

  # Deny a meeting application.
  #
  # @param id [Integer] the meeting id
  # @param remarks [String] the audit results
  # @return [Hash<Symbol => Integer, String >] that contains
  #   `code`   -> result status
  #   `msg`    -> if operation was performed successfully
  #   `error`  -> if operation occurs an error
  def self.deny(id, remarks)
    meeting = find_by(id: id)

    if meeting
      if meeting.status == 'PENDING' || meeting.status == 'PASSED'
        if meeting.update_attributes(status: 'DENIED', remarks: remarks)
          return { code: 200, msg: "Refuse the meeting #{id} success", to: meeting.family.api_key.access_token }
        end

        logger.error "The Meeting: #{id} reject operation failed with error: #{meeting.errors.messages}"
        return { code: 500, error: "Reject meeting: #{id} operation failed" }
      end

      return { code: 400, error: "The meeting: #{id} has been reviewed and can not be reviewed again" }
    end

    { code: 400, error: "Can not refuse a non-existent meeting #{id}" }
  end

  # Payment immediately after the meeting has been successfully created.
  # If the application is rejected or at the date of the application that
  # has not been audited, the system will automatically refund.
  #
  # @param params [Hash<Symbol => String, Integer>] for creating a meeting 
  #   that contains `application_date` and `family_id`
  #
  # @return [Hash<Symbol => Integer, Integer, Integer>] that contains
  #   `code`    -> result status 
  #      1) 200 operation success.
  #      2) 400 within record invalid error. 
  #   `balance` -> new balance after apply a meeting successfully
  #   `cost`    -> the cost per meeting
  def self.application(params)
    begin
      transaction do
        meeting = Meeting.create!(params)
        family = meeting.family
        cost = family.prisoner.jail.configuration.settings["cost"]
        family.update_attributes!(balance: family.balance - cost)
        { code: 200, balance: family.balance, cost: cost }
      end
    rescue ActiveRecord::RecordInvalid => ex 
      { code: 400, errors: ex.message }
    end
  end

  # List meetings by conditions.
  #
  # @param conditions [Hash<Symbol => String>]
  # @return [Hash<Symbol => String>]
  def self.list(conditions)  
    return [ ] unless conditions.has_key?(:jail_id)

    selections = "SELECT m.id, 
                  m.application_date, 
                  m.created_at, 
                  f.name, 
                  f.uuid, 
                  f.phone, 
                  f.relationship, 
                  p.prisoner_number, 
                  m.meeting_time,
                  t.terminal_number,
                  m.status"

    tables = "FROM meetings m 
              INNER JOIN families f ON f.id = m.family_id 
              INNER JOIN prisoners p ON p.id = f.prisoner_id 
              LEFT OUTER JOIN terminals t ON t.id = m.terminal_id"
        
    where_clause = " WHERE "

    # Note: the ordering hash is guaranteed in version 1.9
    # `:jail` must at the first place of the keys in conditions
    # TODO: fix this for no ordering
    conditions.each do |k, v|
      case k
      when :jail_id          then where_clause << "p.jail_id = #{v}" unless v.blank?
      when :application_date then where_clause << " AND m.application_date = '#{v}'" unless v.blank?
      when :status           then where_clause << " AND m.status = '#{v}'" unless v.blank?
      when :query            then where_clause << v unless v.blank?
      else
      end
    end
      
    sql = "#{selections} #{tables} #{where_clause} ORDER BY created_at desc"
    puts 'sql----'+sql
    if conditions[:limit] 
      total = count_by_sql("SELECT COUNT(*) #{tables} #{where_clause};")
      limit = conditions[:limit]
        
      offset = limit.to_i * conditions[:page].to_i
      sql = "#{sql} limit #{limit} offset #{offset}"
      logger.debug sql
      return { total: total, meetings: find_by_sql(sql) }
    end
 
    logger.debug sql
    find_by_sql(sql)
  end

  private 

  def date_validation?
    errors.add(:application_date, '申请日期不能早于或等于当天') if Date.parse(application_date) <= Date.today
  end

  def pending?
    errors.add(:status, '您的申请正在审核中，请勿重复提交') unless Meeting.where("status = 'PENDING' AND family_id = ?", family).empty?
  end

  # Detect whether the maximum number of people has been reached
  # @return [Boolean] 
  def number_limit?
    errors.add(:number_limit, '当日申请已满') if full?
  end

  def passed_meetings_at_application_date
    Meeting.where(terminal: terminals, application_date: application_date, status: 'PASSED').size
  end

  def max_meetings_per_day
    @settings ||= family.prisoner.jail.configuration.settings

    # number of terminals multiply meeting times per terminal contains
    terminals.size * @settings["meeting_queue"].size
  end

  def terminals
    family.prisoner.jail.terminals
  end

  def full?
    passed_meetings_at_application_date == max_meetings_per_day
  end

  def balance_insufficient?
    @settings ||= family.prisoner.jail.configuration.settings
    errors.add(:balance, "余额不足") if family.balance < @settings["cost"]
  end

  def meeting_queues(meeting, terminals_ids)
    Meeting.where(application_date: meeting.application_date, terminal: terminals_ids, status: 'PASSED').
      select(:terminal_id).
      group(:terminal_id).
      count
  end

  def shortest_terminal_id_and_position(ids, queue, &block)
    empty_keys = ids - queue.keys
    return yield queue.sort.min_by{|k,v| v} if empty_keys.empty?
    yield [empty_keys.first, 0]
  end
  
end