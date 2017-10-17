require_relative "./../../spec_helper.rb"

describe FaqModule::ListLinksService do
  it "with list_links command: list all links with number of faqs referenced this link" do
    faq = create(:faq, company: @company)
    link = create(:link, company: @company)
    create(:faq_link, faq: faq, link: link)

    response = FaqModule::ListLinksService.call

    expect(response).to match(link.content)
    expect(response).to match(link.faqs.count.to_s)
  end
end
