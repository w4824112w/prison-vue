class User < ApplicationRecord
  belongs_to :jail

  attr_accessor :password

  validate  :password_must_be_present
  validates :password, :confirmation => true

  def User.encrypt_password(password, salt)
	  BCrypt::Engine.hash_secret(password, salt)
  end

  def User.authenticate(prison, username, password)
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

    User.transaction do
      user.update_attributes!({ hashed_password: encrypt_password(new_password,user.salt) })
    end

    rescue ActiveRecord::RecordInvalid => ex
      return { code: 400, errors: ex.message }

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
