module FaqModule
  class HighlightService
    def initialize(params)
      @company = Company.last
      @id = params["id"]
      @highlight = params["highlight"]
    end

    def call
      faq = @company.faqs.where(id: @id).last
      return "Questão inválida, verifique o Id" if faq.nil?

      Faq.transaction do
        if @highlight
          highlight(faq)
        else
          unhighlight(faq)
        end
      end
    end


    private


    def highlight(faq)
      if faq.highlighted
        "Este item já está destacado"
      else
        faq.update(highlighted: true)
        "Destacado com sucesso"
      end
    end

    def unhighlight(faq)
      if faq.highlighted
        faq.update(highlighted: false)
        "Destaque removido com sucesso"
      else
        "Este item não está destacado"
      end
    end
  end
end
