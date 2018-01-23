class MailBox < ApplicationRecord
  default_scope { order 'created_at desc ' }
  default_scope { where("sys_flag =1")}

  belongs_to :jail
  belongs_to :family

  has_many :comments

  validates :title, :jail_id, :family_id, :contents, :presence => true
end
