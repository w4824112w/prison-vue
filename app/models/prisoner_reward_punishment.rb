class PrisonerRewardPunishment < ApplicationRecord
  
    def self.list(prisoner_number)
        prisoner = Prisoner.find_by_prisoner_number(prisoner_number)
        prisoner_id = prisoner.id

        sql = "select * from prisoner_reward_punishments prp 
        where prp.prisoner_id=#{prisoner_id} order by prp.created_at desc;"        
        res = find_by_sql(sql)
        { total: res.size, data: res }
    end

    def self.upload(file)
        begin        
        name = file.original_filename
        directory="public/upload"
        FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
        path=File.join(directory,name)
        File.open(path,"wb") {|f| f.write(file.read)}

        rescue =>error
          return { code: 500, msg: "文件错误，请重新上传导入" }
        end

        { code: 200, msg: "罪犯奖励惩罚数据导入成功,开始分析处理数据" ,path: path}
    end
    
    def self.import(filepath,jail_id)
        index =0
        path="#{Rails.root}/"+filepath

        begin
            book = Spreadsheet.open path
            sheet1 = book.worksheet 0
            sheet1.each do |row|
                puts "开始读取文件"    
                if index == 0
                    index+=1
                    next
                end

                if prisoner=Prisoner.find_by_prisoner_number_and_jail_id(row[0].to_i, jail_id)
                    PrisonerRewardPunishment.transaction do
                    PrisonerRewardPunishment.create!({prisoner_id: prisoner.id,datayear: row[2], ndry: row[3],rp_type: row[4]})
                  end
                end

            end
    
        rescue =>error
          return { code: 500, msg: "请核对数据格式是否正确！"}
        ensure
          File.delete(path) if File.exist?(path)
        end 
        { code: 200, msg: "罪犯奖励惩罚数据处理完毕" }
    end


end
