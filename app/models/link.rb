class Link < ActiveRecord::Base
  belongs_to :company
  has_many :faq_links, dependent: :destroy
  has_many :faqs, through: :faq_links
end
