module FaqModule
  class RemoveService
    def initialize(params)
      # TODO: identify origin and set company
      @company = Company.last
      @params = params
      @id = params["id"]
    end

    def call
      faq = @company.faqs.where(id: @id).last
      return "Questão inválida, verifique o Id" if faq.nil?

      Faq.transaction do
        # Deleta as tags associadas que não estejam associadas a outros faqs
        faq.hashtags.each do |h|
          if h.faqs.count <= 1
            h.destroy
          end
        end

        faq.links.each do |link|
          link.destroy if link.faqs.count <= 1
        end

        faq.destroy
        "Deletado com sucesso"
      end
    end
  end
end
