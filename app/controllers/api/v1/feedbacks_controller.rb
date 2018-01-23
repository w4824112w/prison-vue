#encoding = utf-8

module Api
  module V1
    class FeedbacksController < ApiController

      def create
        feedback = Feedback.new(feedback_params)
        if feedback.save
          render json: { code: 200 }
          return
        end

        render json: { code: 500, msg: '提交反馈失败,请稍后再试', errors: feedback.errors }
      end

      private

      def feedback_params
        json_params = ActionController::Parameters.new(JSON.parse(request.body.read))
        json_params.require(:feedback).permit(:contents)
      end

    end
  end
end