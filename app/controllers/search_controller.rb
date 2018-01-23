# encoding = utf-8
class SearchController < ApplicationController
  def search
    params[:limit] ||= 10
    params[:page] ||= 0

    conditions = { jail_id: session[:jail_id], limit: params[:limit].to_i, offset: params[:page].to_i * params[:limit].to_i }
    
    # 身份证
    if /\d{15}(\d\d[0-9xX])?/.match(params[:value]) 
      conditions.merge!(query: "uuid='#{params[:value]}' ")
    # 手机号
    elsif /1\d{10}/.match(params[:value])
      conditions.merge!(query: "phone='#{params[:value]}' ")
    # 6-10位囚号
    elsif /^[0-9]{6,10}$/.match(params[:value]) 
      conditions.merge!(query: "prisoner_number='#{params[:value]}'")
    # 姓名
    else
      conditions.merge!(query: "name='#{params[:value]}'")
    end

    values = conditions[:query].split('=')

    case params[:c]
      when 'registrations'
        conditions[:query] = " AND registrations.#{values[0]} = #{values[1]}"
        render json: Registration.list(conditions)
      when 'meetings'
        if values[0] == 'name'
          conditions[:query] = " AND f.name = #{values[1]} "
        elsif values[0] == 'phone'
          conditions[:query] = " AND f.phone = #{values[1]} "
        elsif values[0] == 'prisoner_number'
          conditions[:query] = " AND p.prisoner_number = #{values[1]} "
        else
          conditions[:query] = " AND f.uuid = #{values[1]} "
        end
        render json: Meeting.list(conditions)
      when 'prisoners'
        if values[0] == 'name'
          conditions[:query] = {name: params[:value]}
        elsif values[0] == 'prisoner_number'
          conditions[:query] = { prisoner_number: params[:value] }
        end
        
        render json: Prisoner.list(session[:jail_id], conditions[:limit], conditions[:offset], conditions[:query])
      when 'families'
        if values[0] == 'name'
          conditions[:query] = " prisoners.name = #{values[1]} OR families.name = #{values[1]} "
        elsif values[0] == 'phone'
          conditions[:query] = " families.phone = #{values[1]} "
        else
          conditions[:query] = " families.uuid = #{values[1]} "
        end

        render json: Family.list(session[:jail_id], 0,0, conditions[:query])
      when 'accounts'
        if values[0] == 'name'
          conditions[:query] = " p.name = #{values[1]} "
        else
          conditions[:query] = " p.prisoner_number = #{values[1]} "
        end
        conditions.delete(:limit)
        conditions.delete(:page)
        render json: Account.list(session[:jail_id], 0, 0, conditions)
      when 'terminals'
        render json: Terminal.list(session[:jail_id], conditions[:limit], conditions[:offset], nil)
      when 'versions'
        render json: Version.list(conditions[:limit], conditions[:offset])
    end
    
  end
end
