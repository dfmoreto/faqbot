class Company < ActiveRecord::Base
  validates :name, presence: true
  has_many :faqs
  has_many :hashtags
end
