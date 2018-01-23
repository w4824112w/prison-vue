# An api key used for indicating the user that has the permission 
# to using video meeting and shopping functions 
class ApiKey < ApplicationRecord 
  belongs_to :family

  validates :access_token, :presence => true
end