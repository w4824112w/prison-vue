class UsersController < ApplicationController
    before_action :authenticate!
    
    def index
        render json: current_user.to_json
    end

end
