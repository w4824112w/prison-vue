class ApplicationController < ActionController::API

  attr_accessor :current_user
  
  before_action :cors_preflight_check
  after_action :cors_set_access_control_headers

    protected
  
    def authenticate!
      render_failed and return unless token?
      @current_user = User.find_by(id: auth_token[:user_id])
    #  puts @current_user.inspect
    rescue JWT::VerificationError, JWT::DecodeError
      render_failed
    end
  
    def cors_set_access_control_headers
    #  puts '1111'+request.headers["Origin"]
      headers['Access-Control-Allow-Origin'] = request.headers["Origin"]
      headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, PATCH, OPTIONS, HEAD'
      headers['Access-Control-Request-Method'] = '*'
      headers['Access-Control-Allow-Credentials'] = 'true'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
      headers['Access-Control-Max-Age'] = "1728000"
    end

    def cors_preflight_check
    #  puts '2222'+request.headers["Origin"]+'333'+request.method
      if request.method == :options
       #headers['Access-Control-Allow-Origin'] = 'http://localhost:8080'
     #   puts '2222'+request.headers["Origin"]
       # headers['Access-Control-Allow-Origin'] = 'http://127.0.0.1:8080'
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
  
    def render_failed(messages = ['验证失败'])
      render json: { errors: messages}, status: :unauthorized
    end
  
    def http_token
      @http_token ||= if request.headers['Authorization'].present?
                        request.headers['Authorization'].split(' ').last
                      end
    end
  
    def auth_token
      @auth_token ||= Token.decode(http_token)
    end
  
    def token?
      http_token && auth_token && auth_token[:user_id].to_i
    end

end
