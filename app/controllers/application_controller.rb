require "#{Rails.root}/lib/yunxin"



class ApplicationController < ActionController::Base
  include YunXin
  
  before_action :authorize
  
  layout :detect_user_roles

  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

  def cors_set_access_control_headers
    #puts '1111'+request.headers["Origin"]
    headers['Access-Control-Allow-Origin'] = request.headers["Origin"]
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS, HEAD'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Credentials'] = 'true'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == :options
     #headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
      #puts '2222'+request.headers["Origin"]
      headers['Access-Control-Allow-Origin'] = request.headers["Origin"]
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS, HEAD'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      headers['Access-Control-Max-Age'] = '1728000'
      render :text => '', :content_type => 'text/plain'
    end
  end

  private
  # get the user currently logged in
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  protected


  def authorize
    redirect_to home_path, notice: 'Please Log in' unless User.find_by_id(session[:user_id])
  end

  def detect_user_roles
    case User.find(session[:user_id]).role
      when 1
        'auditor'
      when 2
        'merchant'
      when 3
        'information'
      when 0
        'super_user'
    end
  end
  
  

end
