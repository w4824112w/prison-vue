module Api
  module V1
    class CommentsController < ApiController

      def index
        family = Family.find(params[:id])

        sql = "SELECT m.id, m.title, m.contents, c.contents replies, c.created_at reply_date
               FROM mail_boxes m
               LEFT JOIN comments c ON m.id = c.mail_box_id 
               WHERE m.family_id = #{family.id};"
               
        records_array = ActiveRecord::Base.connection.execute(sql)
        render json: { comments: records_array }
      end

    end
  end
end
