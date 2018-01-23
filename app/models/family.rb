class Family < ApplicationRecord
  default_scope { where(arel_table[:sys_flag ].not_eq(0))}

  belongs_to :prisoner
  has_one :api_key
  
  has_many :orders
  has_many :mail_boxes

  has_many :news_comments
  has_many :news, :through => :news_comments

  has_many :meetings
  has_many :terminals, :through => :meetings
  
  has_many :drawbacks

  has_many :prisoner_orders

  def self.list(jail, limit, offset, opt = nil)
    if opt.nil?
      total = count_by_sql("SELECT COUNT(f.id) FROM families f INNER JOIN prisoners p ON p.id = f.prisoner_id WHERE p.jail_id = #{jail};")
      families = joins(:prisoner).where('prisoners.jail_id = ?', jail).limit(limit).offset(offset)
      
      return { total: total, families: families, prisoners: families.map { |f| f.prisoner } }
    end

    families = joins(:prisoner).where(opt)
    { total: families.size, families: families, prisoners: families.map{ |f| f.prisoner }  }
  end

  def self.login(phone, uuid)
    family = find_by_phone_and_uuid(phone, uuid)

    if family
      jail = family.prisoner.jail

      return { code: 200, 
        id: family.id,
        jail_id: jail.id, 
        name: family.name, 
        phone: family.phone,
        relationship: family.relationship,
        balance: family.balance,
        avatar: family.image_url,
        jail: jail.title,
        modules: jail.configuration.settings["modules"],
        token: family.api_key.access_token
       }
    end

    { code: 401 }
  end

  def self.drawback(access_token)
    family = ApiKey.find_by_access_token(access_token).family
    
    Drawback.transaction do
      Drawback.create!(family_id: family.id, figure: family.balance)
      family.update_attributes!({ balance: 0 })
    end 
  end

end