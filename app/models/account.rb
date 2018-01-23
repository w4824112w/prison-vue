class Account < ApplicationRecord
  belongs_to :prisoner
  has_many :account_details

  def self.list(jail, limit, offset, opt = nil)
    if opt.nil?
      total = count_by_sql("SELECT COUNT(*) FROM prisoners WHERE jail_id = #{jail}")

      sql = "SELECT p.id , p.name, p.prisoner_number, p.crimes,
        a.id as account_id, a.balance FROM prisoners p LEFT OUTER JOIN 
        accounts a ON a.prisoner_id = p.id WHERE p.jail_id = #{jail} limit #{limit} offset #{offset};"

      res = find_by_sql(sql)
      return { total: total, data: res }
    end

    sql = "SELECT p.id , p.name, p.prisoner_number, p.crimes,
    a.id as account_id, a.balance FROM prisoners p LEFT OUTER JOIN 
    accounts a ON a.prisoner_id = p.id WHERE p.jail_id = #{jail} AND #{opt[:query]};"

    res = find_by_sql(sql)
    { total: res.size, data: res }
  end

end
