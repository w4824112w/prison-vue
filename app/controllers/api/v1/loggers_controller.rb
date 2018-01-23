module Api
  module V1
    class LoggersController < ApiController
      skip_before_action :restrict_access

      def create
        app_logger = AppLogger.new(logger_params)
        if app_logger.save
          render json: { code: 200, msg: 'commit success' }
          return
        end

        render json: { code: 400, errors: app_logger.errors }
      end

      private

      def logger_params
        json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_params.require(:logger).permit(:phone, :contents, :device_name, :device_type, :app_version, :sys_version)
      end

    end
  end
end