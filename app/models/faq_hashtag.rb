class FaqHashtag < ActiveRecord::Base
  validates :faq_id, presence: true
  validates :hashtag_id, presence: true

  belongs_to :faq
  belongs_to :hashtag
end
