require_relative './../spec_helper.rb'

describe InterpretService do
  before :each do
    @company = create(:company)
  end

  describe '#list' do
    it "With zero faqs, return don't find message" do
      response = InterpretService.call('list', {})
      expect(response).to match("Nada encontrado")
    end

    it "With two faqs, find questions and answer in response" do
      faq1 = create(:faq, company: @company)
      faq2 = create(:faq, company: @company)

      response = InterpretService.call('list', {})

      expect(response).to match(faq1.question)
      expect(response).to match(faq1.answer)

      expect(response).to match(faq2.question)
      expect(response).to match(faq2.answer)
    end
  end

  describe '#search' do
    it "With empty query, return don't find message" do
      response = InterpretService.call('search', {"query": ''})
      expect(response).to match("Nada encontrado")
    end

    it "With valid query, find question and answer in response" do
      faq = create(:faq, company: @company)

      response = InterpretService.call('search', {"query" => faq.question.split(" ").sample})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#search by category' do
    it "With invalid hashtag, return don't find message" do
      response = InterpretService.call('search_by_hashtag', {"query": ''})
      expect(response).to match("Nada encontrado")
    end

    it "With valid hashtag, find question and answer in response" do
      faq = create(:faq, company: @company)
      hashtag = create(:hashtag, company: @company)
      create(:faq_hashtag, faq: faq, hashtag: hashtag)

      response = InterpretService.call('search_by_hashtag', {"query" => hashtag.name})

      expect(response).to match(faq.question)
      expect(response).to match(faq.answer)
    end
  end

  describe '#create' do
    before do
      @question = FFaker::Lorem.sentence
      @answer = FFaker::Lorem.sentence
      @hashtags = "#{FFaker::Lorem.word}, #{FFaker::Lorem.word}"
    end

    it "Without hashtag params, receive a error" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer})
      expect(response).to match("Hashtag Obrigatória")
    end

    it "With valid params, receive success message" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags})
      expect(response).to match("Criado com sucesso")
    end

    it "With valid params, find question and anwser in database" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags})
      expect(Faq.last.question).to match(@question)
      expect(Faq.last.answer).to match(@answer)
    end

    it "With valid params, hashtags are created" do
      response = InterpretService.call('create', {"question-original" => @question, "answer-original" => @answer, "hashtags-original" => @hashtags})
      expect(@hashtags.split(/[\s,]+/).first).to match(Hashtag.first.name)
      expect(@hashtags.split(/[\s,]+/).last).to match(Hashtag.last.name)
    end
  end

  describe '#remove' do
    it "With valid ID, remove Faq" do
      faq = create(:faq, company: @company)
      response = InterpretService.call('remove', {"id" => faq.id})
      expect(response).to match("Deletado com sucesso")
    end

    it "With invalid ID, receive error message" do
      response = InterpretService.call('remove', {"id" => rand(1..9999)})
      expect(response).to match("Questão inválida, verifique o Id")
    end
  end

  describe "#link_links" do
    it "list links with number of faqs referenced it" do
      faq = create(:faq, company: @company)
      link = create(:link, company: @company)
      create(:faq_link, faq: faq, link: link)

      response = InterpretService.call('list_links', {})
      expect(response).to match(link.content)
      expect(response).to match(link.faqs.count.to_s)
    end
  end

  describe "#highlight" do
    it "highlight item if its not highlighted" do
      faq = create(:faq, company: @company)
      response = InterpretService.call('highlight', {"id" => faq.id})
      faq.reload
      expect(faq.highlighted).to be_truthy
    end

    it "return an error if item is already highlighted" do
      faq = create(:faq, highlighted: true, company: @company)
      response = InterpretService.call('highlight', {"id" => faq.id})
      expect(response).to match('Este item já está destacado')
    end

    it "with invalid id, return error message" do
      response = InterpretService.call('highlight', {"id" => rand(1..9999)})
      expect(response).to match("Questão inválida, verifique o Id")
    end
  end

  describe "#unhighlight" do
    it "unhighlight item if its highlighted" do
      faq = create(:faq, highlighted: true, company: @company)
      response = InterpretService.call('unhighlight', {"id" => faq.id})
      faq.reload
      expect(faq.highlighted).to be_falsy
    end

    it "return an error if item is not highlighted" do
      faq = create(:faq, highlighted: false, company: @company)
      response = InterpretService.call('unhighlight', {"id" => faq.id})
      expect(response).to match('Este item não está destacado')
    end

    it "with invalid id, return error message" do
      response = InterpretService.call('unhighlight', {"id" => rand(1..9999)})
      expect(response).to match("Questão inválida, verifique o Id")
    end
  end
end
