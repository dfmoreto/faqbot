FactoryGirl.define do
  factory :link do
    content FFaker::Internet.http_url
    company
  end
end
