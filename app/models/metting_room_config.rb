class MettingRoomConfig < ApplicationRecord

  belongs_to :jail

  def self.list(number)
    res = find_by_sql("SELECT * FROM terminals WHERE terminal_number = #{number};")
    jail_id = res[0].jail_id
    
    mettings = find_by_sql("select mrc.*,
    CONCAT(mrc.room_number,'##',mrc.host_password,'##',mrc.metting_password) as content
    from metting_room_configs mrc where mrc.jail_id = #{jail_id};")
    
    {code: 200,total:res.size , mettings: mettings }
  end


  
end
