class User < ApplicationRecord
#  has_secure_password
  belongs_to :jail

 # attr_accessor :password

 # validate  :password_must_be_present
 # validates :password, :confirmation => true

  def token
    {
      token: Token.encode(user_id: self.id)
    }
  end

  def to_json
    puts self.inspect
  #  @zipcode = self.jail.zipcode
  #  puts 'zipcode---'+@zipcode
    {id: self.id, username: self.username, role_id: self.role, jail_id: self.jail.id, zipcode: self.jail.zipcode, created_at: self.created_at }
   # self.slice(:id, :username, :role, :jail_id.to_s, :created_at.to_s)
  end

  def User.encrypt_password(password, salt)
	  BCrypt::Engine.hash_secret(password, salt)
  end

  def User.authenticate(prison, username, password)
  #  puts '1111'+prison
  #  puts '2222'+username
  #  puts '3333'+password
	  if prison = Jail.find_by_zipcode(prison)
	    if user = User.find_by_username_and_jail_id(username, prison.id)
		    if user.hashed_password == encrypt_password(password, user.salt)
		      user
		    end
	    end
	  end
  end

  def User.modify(zipcode, username, password,new_password)
    user=authenticate(zipcode,username,password)

    unless user
      return { code: 500, msg: "原始密码错误" }
    end

    begin 
      User.transaction do
        user.update_attributes!({ hashed_password: encrypt_password(new_password,user.salt) })
      end 
      rescue ActiveRecord::RecordInvalid => ex
        return { code: 400, errors: ex.message } 
    end
    { code: 200, msg: "修改密码成功" }
  end

  def password=(password)
    @password = password

    if password.present?
      generate_salt
      self.hashed_password = self.class.encrypt_password(password, salt)
    end

  end

  private

  def password_must_be_present
    errors.add(:password, 'Missing password') unless hashed_password.present?
  end

  def generate_salt
    self.salt = BCrypt::Engine.generate_salt
  end

end
