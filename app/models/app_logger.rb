class AppLogger < ApplicationRecord
  default_scope { order 'created_at desc' }
  validates :contents, :phone, :device_name, :device_type, :sys_version, :app_version, :presence => true
end
