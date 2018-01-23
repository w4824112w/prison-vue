module Api
  module V1
    class MailBoxesController < ApiController

      def create
        message = MailBox.new(message_params)
        if message.save
          render json: { code: 200 }
          return
        end

        render json: { code: 400, errors: message.errors }
      end

      def index
        render json: { code: 200, mails: MailBox.where(family_id: params[:id])}
      end

      private

      def message_params
        json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_params.require(:message).permit(:title, :contents, :jail_id, :family_id)
      end

    end
  end
end