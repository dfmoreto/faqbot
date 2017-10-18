FactoryGirl.define do
  factory :faq do
    question FFaker::Lorem.phrase
    answer FFaker::Lorem.phrase
    highlighted false
    company
  end
end
