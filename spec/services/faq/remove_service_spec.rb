require_relative './../../spec_helper.rb'

describe FaqModule::RemoveService do
  before do
    @company = create(:company)
  end

  describe '#call' do
    it "With valid ID, remove Faq" do
      faq = create(:faq, company: @company)
      @removeService = FaqModule::RemoveService.new({"id" => faq.id})
      response = @removeService.call()

      expect(response).to match("Deletado com sucesso")
    end

    it "With invalid ID, receive error message" do
      @removeService = FaqModule::RemoveService.new({"id" => rand(1..9999)})
      response = @removeService.call()

      expect(response).to match("Questão inválida, verifique o Id")
    end

    it "With valid ID, remove Faq from database" do
      faq = create(:faq, company: @company)
      @removeService = FaqModule::RemoveService.new({"id" => faq.id})

      expect(Faq.all.count).to eq(1)
      response = @removeService.call()
      expect(Faq.all.count).to eq(0)
    end

    it "without any associated faqs, also remove link" do
      faq = create(:faq, company: @company)
      link = create(:link, company: @company)
      create(:faq_link, faq: faq, link: link)
      @removeService = FaqModule::RemoveService.new({'id' => faq.id})

      expect {
        @removeService.call
      }.to change(Link, :count).by(-1)
    end

    it "with associated faqs, doesn't remove link" do
      faq1 = create(:faq, company: @company)
      faq2 = create(:faq, company: @company)
      link = create(:link, company: @company)
      create(:faq_link, faq: faq1, link: link)
      create(:faq_link, faq: faq2, link: link)
      @removeService = FaqModule::RemoveService.new({'id' => faq1.id})

      expect {
        @removeService.call
      }.to_not change(Link, :count)
    end
  end
end
