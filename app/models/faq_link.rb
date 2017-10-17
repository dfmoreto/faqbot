class FaqLink < ActiveRecord::Base
  belongs_to :faq
  belongs_to :link
end
