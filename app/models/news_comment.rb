class NewsComment < ApplicationRecord
    belongs_to :family
    belongs_to :news

    validates :content, presence: true
    
    def self.send_comment(news_id, family_id, content)
      comment = NewsComment.new(news_id: news_id, family_id: family_id, content: content)
      
      if comment.save
          return { code: 200, msg: 'Comment success' }
      end

      { code: 400, msg: 'Comment failed' }
    end
end
