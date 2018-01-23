module Api
  module V1
    class NewsController < ApiController
      skip_before_action :restrict_access, :only => [:index]

      def index
        news = News.where(jail_id: params[:id])
        unless news.empty?
          news = news.map do |n|
            { id: n.id, title: n.title, contents: n.contents, is_focus: n.is_focus, image: n.image_url, updated_at: n.updated_at, type_id: n.type_id }
          end
        end

        render json: { code:200, news: news }
      end

      def comment
        news = News.find(params[:id])
        render json: NewsComment.send_comment(news.id, params[:family_id], params[:content])
      end

      def comment_list
        render json: News.find(params[:id]).news_comments
      end

    end
  end
end