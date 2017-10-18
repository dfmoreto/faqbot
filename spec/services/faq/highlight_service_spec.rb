require_relative './../../spec_helper.rb'

describe FaqModule::HighlightService do
  before do
    @company = create(:company)
  end

  describe 'highlight' do
    it "With valid ID, highlight Faq" do
      faq = create(:faq, company: @company)
      @highlightService = FaqModule::HighlightService.new({"id" => faq.id, "highlight" => true})
      response = @highlightService.call()
      faq.reload
      expect(faq.highlighted).to be_truthy
    end

    it "With item that is already highlighted" do
      faq = create(:faq, highlighted: true, company: @company)
      @highlightService = FaqModule::HighlightService.new({"id" => faq.id, "highlight" => true})
      response = @highlightService.call()

      expect(response).to match("Este item já está destacado")
    end

    it "With invalid ID, receive error message" do
      @highlightService = FaqModule::HighlightService.new({"id" => rand(1..9999), "highlight" => true})
      response = @highlightService.call()

      expect(response).to match("Questão inválida, verifique o Id")
    end
  end

  describe 'unhighlight' do
    it "With valid ID, unhighlight Faq" do
      faq = create(:faq, highlighted: true, company: @company)
      @unhighlightService = FaqModule::HighlightService.new({"id" => faq.id, "highlight" => false})
      response = @unhighlightService.call()
      faq.reload
      expect(faq.highlighted).to be_falsy
    end

    it "with a faq that is not highlighted" do
      faq = create(:faq, highlighted: false, company: @company)
      @unhighlightService = FaqModule::HighlightService.new({"id" => faq.id, "highlight" => false})
      response = @unhighlightService.call()

      expect(response).to match("Este item não está destacado")
    end

    it "With invalid ID, receive error message" do
      @unhighlightService = FaqModule::HighlightService.new({"id" => rand(1..9999), "highlight" => false})
      response = @unhighlightService.call()

      expect(response).to match("Questão inválida, verifique o Id")
    end
  end
end
