class User < ApplicationRecord
  has_secure_password
  belongs_to :jail

    def token
      {
        token: Token.encode(user_id: self.id)
      }
    end
  
    def to_json
     # puts self.inspect
      self.slice(:id, :username, :role, :jail_id.to_s, :created_at.to_s)
    end

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

end
