class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :family
  belongs_to :mail_box
end
