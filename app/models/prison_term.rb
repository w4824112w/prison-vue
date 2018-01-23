class PrisonTerm < ApplicationRecord

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

        { code: 200, msg: "罪犯刑期变动数据导入成功,开始分析处理数据" ,path: path}
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
                  PrisonTerm.transaction do
                    PrisonTerm.create!({term_start: row[1],term_finish: row[8], prisoner_id: prisoner.id, changetype: row[2], sentence: row[3], courtchange: row[4], changeyear: row[5], changemonth:row[6], changeday:row[7]})
                  end
                end

            end
    
        rescue =>error
        #  puts error
          return { code: 500, msg: "文件错误，请重新上传导入" }
        ensure
          File.delete(path) if File.exist?(path)
        end 
        { code: 200, msg: "罪犯刑期变动数据处理完毕" }
    end

    def self.detail(prisoner_number)
        prisoner = Prisoner.find_by_prisoner_number(prisoner_number)
        prisoner_id = prisoner.id

        sql = "select pt.sentence,pt.changetype,pt.term_start,pt.term_finish,
        CONCAT(left(pt.sentence,LENGTH(pt.sentence)-4),'年',substring(pt.sentence,LENGTH(pt.sentence)-3, 2),'个月',right(pt.sentence, 2),'天') as sentence_desc,
        left(pt.sentence,LENGTH(pt.sentence)-4) as sentence_year,
        substring(pt.sentence,LENGTH(pt.sentence)-3, 2) as sentence_month, 
         right(pt.sentence, 2) as sentence_day,
        pt.courtchange,pt.changeyear,pt.changemonth,pt.changeday
         from prison_terms pt 
        where pt.prisoner_id=#{prisoner_id} order by pt.term_start desc;"
    
        res = find_by_sql(sql)

        { total: res.size, data: res }
      end

end
