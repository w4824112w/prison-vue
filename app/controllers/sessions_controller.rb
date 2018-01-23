# encoding = utf-8

class SessionsController < ApplicationController
  skip_before_action :authorize

  def create
    @user = User.authenticate(params[:prison], params[:username], params[:password])
    unless @user
      redirect_to home_path, alert: '用户名或密码错误!'
      return
    end

    session[:user_id] = @user.id
    session[:user_name] = @user.username
    session[:user_role] = @user.role

    @jail = @user.jail
    session[:jail_id] = @jail.id
    session[:jail_title] = @jail.title
    session[:accid] = @jail.accid
    session[:zipcode] = @jail.zipcode

    case session[:user_role]
    when 1
      redirect_to dashboard_path
    when 2
      redirect_to items_path
    when 3
      redirect_to jails_path
    when 0
      redirect_to super_user_index_path
    else
      # 401 page
    end
  end

  def destroy
    session[:user_id] = nil
    session[:user_name] = nil
    session[:jail_id] = nil
    session[:jail_title] = nil
    session[:user_role] = nil
    session[:accid] = nil
    session[:zipcode] = nil

    redirect_to home_path, notice: 'Logged out'
  end

end
