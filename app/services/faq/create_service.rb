module FaqModule
  class CreateService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @question = params["question-original"]
      @answer = params["answer-original"]
      @hashtags = params["hashtags-original"]
    end

    def call
      return "Hashtag Obrigatória" if @hashtags.nil?
      Faq.transaction do
        faq = Faq.create(question: @question, answer: @answer, company: @company)
        @hashtags.split(/[\s,]+/).each do |hashtag|
          faq.hashtags << Hashtag.create(name: hashtag)
        end
        identified_urls(@question + @answer).each do |url|
          faq.links << Link.find_or_create_by(content: url)
        end
      end
      "Criado com sucesso"
    end


    private


    def identified_urls(content)
      matched = content.scan /(http[s]?:\/\/[\w+\.?]*[\/?\w+]*)\s/
      matched.flatten
    end
  end
end
