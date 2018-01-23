class Prisoner < ApplicationRecord
  #default_scope { where(arel_table[:sys_flag].not_eq(0))}

  has_one    :account

  has_many   :families
  has_many   :prison_terms

  belongs_to :jail

  def self.list(jail, limit, offset, opts = nil)
    total = find_by_sql("SELECT COUNT(*) FROM prisoners p WHERE p.jail_id = #{jail};")

    if opts.nil?
      prisoners = where('jail_id = ?', jail).limit(limit).offset(offset) 
    else
      prisoners = where(opts.merge(jail_id: jail)).limit(limit).offset(offset) 
    end
    
    { total: total, families: prisoners.map { |prisoner| prisoner.families }, prisoners: prisoners }
  end

  def self.upload(file)
    begin
    name = file.original_filename
    directory="public/upload"
    FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
    path=File.join(directory,name)
    File.open(path,"wb") { |f| f.write(file.read) }

    rescue =>error
      return { code: 500, msg: "文件错误，请重新上传导入" }
    end
    { code: 200, msg: "罪犯数据导入成功,开始分析处理数据" ,path: path}
  end

  def self.import(filepath,jail_id)
    index =0
    path="#{Rails.root}/"+filepath

    success_total=0
    add_total=0
    update_total=0
    begin
      book = Spreadsheet.open path
      sheet1 = book.worksheet 0
      sheet1.each do |row|
        puts "开始读取文件"  
        if index == 0
          index+=1
          next
        end
  
        success_total+=1
        gender='m'  
        if row[2]=='女'
          gender='f'
        end  

        if prisoner=find_by_prisoner_number_and_jail_id(row[0].to_i, jail_id)
          Prisoner.transaction do
            prisoner.update_attributes!({ name: row[1], gender:gender, crimes:row[3],additional_punishment:row[4],prison_term_started_at:row[5],prison_term_ended_at:row[6],original_sentence:row[8] })
            update_total+=1
          end

          Account.create!({prisoner_id: prisoner.id, balance: 0}) unless Account.find_by_prisoner_id(prisoner.id)
          index+=1
          next
        end

        Prisoner.transaction do
          prisoner=Prisoner.create!({jail_id: jail_id, prisoner_number: row[0].to_i, name: row[1] ,gender:gender,crimes:row[3],additional_punishment:row[4],prison_term_started_at:row[5],prison_term_ended_at:row[6],prison_area:'',original_sentence:row[8]})
          account=Account.create!({prisoner_id: prisoner.id, balance: 0, created_at: Time.new})
          add_total+=1
        end
      end
  
      rescue =>error
      #  puts error
        return { code: 500, msg: "请核对数据格式是否正确！" }
      ensure
        File.delete(path) if File.exist?(path)
    end
     #  puts "success_total--"+success_total+"--add_total--"+add_total+"--update_total--"+update_total
       { code: 200, msg: "罪犯数据处理完毕" ,success_total:success_total, add_total:add_total, update_total:update_total}
  end

  def self.import_bak(filepath,jail_id)
  
    index =0
    path="#{Rails.root}/"+filepath
  begin
    CSV.open(path,"rb").each do |row|
      if index == 0
        index+=1
        next
      end

      name_parse=row[1].to_s.encode(Encoding.find("UTF-8"),Encoding.find("gbk"))

      if find_by_prisoner_number_and_jail_id(row[0], jail_id)
        index+=1
        next
      end

      Prisoner.transaction do
        prisoner=Prisoner.create!({jail_id: jail_id, prisoner_number: row[0], name: name_parse ,gender:'m',crimes:'',prison_area:''})
      end
    end

    rescue =>error
      return { code: 500, msg: "请核对数据格式是否正确！" }
    ensure
      File.delete(path) if File.exist?(path)
    end
     { code: 200, msg: "罪犯数据处理完毕" }
  end

  def self.upload_img(file)
    begin
      name =Time.now.to_i.to_s+file.original_filename[/\.[^\.]+$/]
    #  puts "name:"+name
      directory="public/upload"
      FileUtils.mkdir("#{Rails.root}/public/upload") unless File.exist?("#{Rails.root}/public/upload")
      path=File.join(directory,name)
      File.open(path,"wb") { |f| f.write(file.read) }
      url="/upload/"+name
    rescue =>error
      return { code: 500, error:0,msg: "文件错误，请重新上传导入",url: url }
    end
    { code: 200, error:0, msg: "罪犯数据导入成功,开始分析处理数据" ,url: url}
  end

  def self.del_img(imgsArr)
    imgsArr.each do |img|
      puts "path:"+img
      path="#{Rails.root}/public"+img
      File.delete(path) if File.exist?(path)
    end
  { code: 200, error:0, msg: "清除富文本图片缓存成功" ,}
  end

  def self.detail(prisoner_number)
    prisoner = Prisoner.find_by_prisoner_number(prisoner_number)
    prisoner_id = prisoner.id

    sql = "select p.`name`,p.original_sentence,p.prisoner_number,p.created_at,p.updated_at,p.gender,p.prison_term_started_at,
    p.prison_term_ended_at,p.crimes,p.additional_punishment,p.prison_area
     from prisoners p where p.id= #{prisoner_id};"

    res = find_by_sql(sql)

    prison_terms = find_by_sql("select sentence,term_start,term_finish,
    CONCAT(left(sentence,LENGTH(sentence)-4),'年',substring(sentence,LENGTH(sentence)-3, 2),'个月',right(sentence, 2),'天') as sentence_desc,       
    left(sentence,LENGTH(sentence)-4) as sentence_year,
    substring(sentence,LENGTH(sentence)-3, 2) as sentence_month, 
    right(sentence, 2) as sentence_day 
     from prison_terms  where prisoner_id= #{prisoner_id} order by term_start desc;")

    if prison_terms.size>0
      term_start = prison_terms[0].term_start
      term_finish = prison_terms[0].term_finish
      sentence = prison_terms[0].sentence
      sentence_desc = prison_terms[0].sentence_desc
      sentence_year = prison_terms[0].sentence_year
      sentence_month = prison_terms[0].sentence_month
      sentence_day = prison_terms[0].sentence_day
    end  

     {code: 200, data: { 
        name: res[0].name,
        original_sentence: res[0].original_sentence,
        gender: res[0].gender,
        crimes: res[0].crimes,
        additional_punishment: res[0].additional_punishment,
        prisoner_number: res[0].prisoner_number,
        started_at: res[0].prison_term_started_at,
        ended_at: res[0].prison_term_ended_at,
        created_at: res[0].created_at,
        updated_at: res[0].updated_at,
        prison_area: res[0].prison_area,
        times: prison_terms.size,
        term_start: term_start,
        term_finish: term_finish,
        sentence: sentence,
        sentence_desc: sentence_desc,
        sentence_year: sentence_year,
        sentence_month: sentence_month,
        sentence_day: sentence_day} 
   }
  end
  
end
