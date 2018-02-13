# 
class Registration < ApplicationRecord
  default_scope { order 'created_at DESC' }

  belongs_to :jail
  has_many :uuid_images

  accepts_nested_attributes_for :uuid_images, allow_destroy: true

  validates :name, :phone, :gender, :uuid, :jail_id, :prisoner_number, :relationship, :presence => true
#  validates :phone, uniqueness: true, unless: Proc.new { Registration.where(phone: phone, status: ['PENDING', 'PASSED']).empty? }
  validate :prisoner_exist?, on: :create
  # Return a hash within total and pagined registrations by conditions
  def self.list(conditions)
    return [ ] unless conditions.has_key?(:jail_id)
    
    sql = "SELECT * FROM registrations"
    where_clause = " WHERE "

    conditions.each do |k, v|
      case k
      when :jail_id then where_clause << " registrations.jail_id = #{v}" unless v.blank?
      when :status then where_clause << " AND registrations.status = '#{v}'" unless v.blank?
      when :query then where_clause << v
      else
      end
    end

    # Paginged registrations
    if conditions[:limit]
      total = count_by_sql("SELECT COUNT(*) FROM registrations #{where_clause}")
      registrations = find_by_sql(sql << where_clause << " ORDER BY created_at DESC LIMIT #{conditions[:limit]} OFFSET #{conditions[:offset]};")
    
    # without pagin
    else
      registrations = find_by_sql(sql << where_clause << " ORDER BY created_at DESC;")
      total = registrations.size
    end

    { total: total, registrations: registrations }
  end

  def authorization(status, remarks)
    puts 'status--'+status+'---remarks--'+remarks
    if status == 'DENIED'
      return reject_registration(remarks)
    end

    begin
      agree_registration
    rescue ActiveRecord::RecordInvalid => ex
      #puts ex
      { code: 400, errors: "errors #{ex}" }
    rescue ActiveRecord::RecordNotFound => ex
      { code: 404, errors: "prisoner #{prisoner_number} not found" }
    rescue ActiveRecord::StatementInvalid => ex
      { code: 500, errors: "Internal errors" }
    end
  end
  
  private 
  
  def prisoner_exist?
    if Prisoner.find_by_prisoner_number_and_jail_id(prisoner_number, jail_id).nil?
      errors.add(:create, "prisoner #{prisoner_number} is not exist")
    end
  end

  def reject_registration(remarks)
    if update_attributes(status: 'DENIED', remarks: remarks)
      return { code: 200, msg: remarks }
    end

    logger.error "reject registration #{id} #{errors}"
    { code: 500, error: errors }
  end

  def agree_registration  
    images = uuid_images.map{ |i| i.image.url }.map { |url| url.rindex('?').nil? ? url : url.slice(0, url.rindex('?')) }

    transaction do
      if registration = Registration.find_by_phone_and_status(phone, 'PENDING')
        Registration.transaction do
          registration.update_attributes!({status: 'PASSED'})
        end
      end

      # Specify a prisoner with jail and prisoner number
      prisoner = Prisoner.find_by_prisoner_number_and_jail_id(prisoner_number, jail_id)
      raise ActiveRecord::RecordNotFound unless prisoner

      # Create a family for this prisoner(save all family's images url in one field seperate by '|')
      family = prisoner.families.create!({name: name, 
                                          uuid: uuid, 
                                          phone: phone, 
                                          relationship: relationship, 
                                          image_url: images.join('|')})


      api_key = ApiKey.new(family_id: family.id)
      begin
        api_key.access_token = SecureRandom.hex
      end while api_key.class.exists?(access_token: api_key.access_token)

      api_key.save!

      create_accid(api_key.access_token, images[2])    
    end
  end

  def create_accid(accid, image)
    domain = 'https://www.fushuile.com'
    avatar = image.nil? ? "#{domain}/images/default/missing.jpeg" : "#{domain}#{image}" 
    puts 'accid--'+accid+'--name--'+self.name+'--avatar--'+avatar
       GenerateAccidWorker.perform_async(accid, self.name, avatar)
    { code: 200, msg: 'create success' }   
  end
end