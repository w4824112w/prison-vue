class CreateAppLoggers < ActiveRecord::Migration[5.0]
  def change
    create_table :app_loggers do |t|
      t.string :phone
      t.string :contents
      t.string :device_name
      t.string :sys_version
      t.string :device_type
      t.string :app_version

      t.timestamps
    end
  end
end
