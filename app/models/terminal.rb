class Terminal < ApplicationRecord
  belongs_to :jail

  has_many :meetings
  has_many :families, :through => :meetings

  def self.list(jail, limit, offset, opts = nil)
    total = find_by_sql("SELECT COUNT(*) FROM terminals t WHERE t.jail_id = #{jail};")

    if opts.nil?
      terminals = where('jail_id = ?', jail).limit(limit).offset(offset)
    else
      terminals = where(opts.merge(jail_id: jail)).limit(limit).offset(offset)
    end
    { total: total,  terminals: terminals }
  end

  def self.meeting_list(terminal_number, application_date)
    terminal = find_by(terminal_number: terminal_number)

    if terminal
      meeting_list = terminal.
        meetings.
        where(" application_date = ? AND status != 'PENDING' AND status != 'DENIED' " , application_date).map do |meeting|
          prisoner = meeting.family.prisoner
          { id: meeting.id,
            to: meeting.family.phone,
            meeting_time: meeting.meeting_time,
            prisoner_name: prisoner.name,
            area: prisoner.prison_area,
            status: meeting.status,
            remarks: meeting.remarks }
        end

      return { code: 200, meetings: meeting_list }
    end

    { code: 404 }
  end

  def self.detail(terminal_number)
    res = find_by_sql("select t.terminal_number,t.room_number,t.host_password,t.metting_password,
    CONCAT(t.room_number,'##',t.host_password,'##',t.metting_password) as content
     from terminals t where t.terminal_number = #{terminal_number};")

     {code: 200, data: {
        terminal_number: res[0].terminal_number,
        room_number: res[0].room_number,
        host_password: res[0].host_password,
        metting_password: res[0].metting_password,
        content: res[0].content}
    }
  end

end
