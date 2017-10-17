require "pg_search"
include PgSearch

class Faq < ActiveRecord::Base

  validates :question, presence: true
  validates :answer, presence: true

  has_many :faq_hashtags
  has_many :hashtags, through: :faq_hashtags
  belongs_to :company

  has_many :faq_links, dependent: :destroy
  has_many :links, through: :faq_links

  # include PgSearch
  pg_search_scope :search, against: [:question, :answer]
end
