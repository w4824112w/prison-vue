class PrisonerOrder < ApplicationRecord
    has_many   :prisoner_order_details
    
    belongs_to :jail
    belongs_to :family

    def self.list(jail, limit, offset)
        total = find_by_sql("SELECT COUNT(*) FROM prisoner_orders p WHERE p.jail_id = #{jail};")
        prisoner_orders = where('jail_id = ?', jail).limit(limit).offset(offset)

        { total: total, prisoner_order_details: prisoner_orders.map { |prisoner_order| prisoner_order.prisoner_order_details }, prisoner_orders: prisoner_orders }
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

        { code: 200, msg: "罪犯订单商品数据导入成功,开始分析处理数据" ,path: path}
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
            
            #   puts "参数中文转码begin..."

                status_parse=row[0]
                ifreceive_parse=row[1]
                goods_details_parse=row[4] 
                goods_name_parse=row[7]
                order_details_parse=row[8]
                payment_type_parse=row[11]

            #   puts "status_parse--"+status_parse+"--ifreceive_parse--"+ifreceive_parse+"--goods_details_parse--"+goods_details_parse+"--goods_name_parse--"+goods_name_parse+"--order_details_parse--"+order_details_parse+"--payment_type_parse--"+payment_type_parse
            #   puts "参数中文转码end..."

                prisoner_number=row[5]

                prisoner=Prisoner.find_by_prisoner_number_and_jail_id(prisoner_number, jail_id)
                
                prisoner.families.each do |f|
                    transaction do
                        prisoner_order=PrisonerOrder.create!({trade_no: row[3],jail_id: jail_id, payment_type: payment_type_parse, status: status_parse, ifreceive: ifreceive_parse ,created_at: row[2],updated_at: row[10],amount: row[12],family_id: f.id,order_details: order_details_parse,total: row[6]})
                        prisoner_order_detail  = PrisonerOrderDetail.new(prisoner_orders_id: prisoner_order.id,prisoner_id: f.prisoner_id,goods_name: goods_name_parse,goods_price: row[13],goods_details: goods_details_parse,goods_num: row[15] )
                        prisoner_order_detail.save!
                    end
                end

            end
    
        rescue =>error
          return { code: 500, msg: "请核对数据格式是否正确！" }
        ensure
          File.delete(path) if File.exist?(path)
        end 
        { code: 200, msg: "罪犯订单商品数据处理完毕" }
    end

    def self.import_bak(filepath,jail_id)
        index =0
        path="#{Rails.root}/"+filepath     

        begin
            CSV.open(csv_path,"rb").each do |row|
                puts "开始读取文件"    
                if index == 0
                    index+=1
                    next
                end
            
            #   puts "参数中文转码begin..."

                status_parse=row[0].to_s.encode(Encoding.find("UTF-8"),Encoding.find("gbk")) 
                ifreceive_parse=row[1].to_s.encode(Encoding.find("UTF-8"),Encoding.find("gbk")) 
                goods_details_parse=row[4].to_s.encode(Encoding.find("UTF-8"),Encoding.find("gbk")) 
                goods_name_parse=row[7].to_s.encode(Encoding.find("UTF-8"),Encoding.find("gbk"))
                order_details_parse=row[8].to_s.encode(Encoding.find("UTF-8"),Encoding.find("gbk"))
                payment_type_parse=row[11].to_s.encode(Encoding.find("UTF-8"),Encoding.find("gbk"))

            #   puts "status_parse--"+status_parse+"--ifreceive_parse--"+ifreceive_parse+"--goods_details_parse--"+goods_details_parse+"--goods_name_parse--"+goods_name_parse+"--order_details_parse--"+order_details_parse+"--payment_type_parse--"+payment_type_parse
            #   puts "参数中文转码end..."

                prisoner_number=row[5]
                prisoner=Prisoner.find_by_prisoner_number_and_jail_id(prisoner_number, jail_id)

                prisoner.families.each do |f|
                    transaction do
                        prisoner_order=PrisonerOrder.create!({trade_no: row[3],jail_id: jail_id, payment_type: payment_type_parse, status: status_parse, ifreceive: ifreceive_parse ,created_at: row[2],updated_at: row[10],amount: row[12],family_id: f.id,order_details: order_details_parse,total: row[6]})
                        prisoner_order_detail  = PrisonerOrderDetail.new(prisoner_orders_id: prisoner_order.id,prisoner_id: f.prisoner_id,goods_name: goods_name_parse,goods_price: row[13],goods_details: goods_details_parse,goods_num: row[15] )
                        prisoner_order_detail.save!
                    end
                end

            end
    
        rescue =>error
          return { code: 500, msg: "文件错误，请重新上传导入" }
        ensure
          File.delete(path) if File.exist?(path)
        end 
        { code: 200, msg: "罪犯订单商品数据处理完毕" }
    end

   # def self.test
    #    @excel_file=File.open("#{Rails.root}/"+path, "rb")
    #    puts "666666666666----"+excel_file
    #    puts "44444---"+excel_file.split('.').first

        #验证文件格式
     #   puts "99999999999999999"
     #   file_extend_name= path.split('.').last

     #   puts "222222222222222222222222222----"+file_extend_name

      #  case file_extend_name
      #  when "xls"
      #      xls = true
      #  when "xlsx"
     #       xlsx = true
      #  else
     #       xls = xlsx = false
    #    end

        #根据不同格式分别处理，并转换为csv文件
    #    if xls
     #       puts "999999999"
        #   csv_file = Excel.new(excel_file)
    #        puts "8888888"
    #       file_name = excel_file.split('.').first
     #       puts "file_name----"+file_name
     #      puts "正在读取excel文件 ->", excel_file.inspect
      #      puts "读取excel文件完毕，正在转换生成对应的csv文件,请稍等..."
      #      excel_file.to_csv("#{file_name}.csv")
      #      puts "xls转成csv文件完毕！"
      #  elsif xlsx
      #      csv_file = Excelx.new(excel_file)
     #       file_name = excel_file.split('.').first
     #       puts "正在读取excel文件 ->", excel_file.inspect
      #      puts "读取excel文件完毕，正在转换生成对应的csv文件,请稍等..."
      #      csv_file.to_csv("#{file_name}.csv")
     #       puts "xlsx转成csv文件完毕！"
      #  end
     #   puts "转化文件结束...."
  #  end    

end
