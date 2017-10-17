module FaqModule
  class ListLinksService
    def self.call
      @company = Company.last
      response = "*Links Agregados* \n\n"
      Link.where(company: @company).each do |link|
        response += "*#{link.content}*\n"
        response += ">Quant. Referencias: #{link.faqs.count}\n"
        response += "\n\n"
      end
      (Link.count > 0)? response : "Nada encontrado"
    end
  end
end
