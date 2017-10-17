module FaqModule
  class ListLinksService
    def self.call
      response = "*Links Agregados* \n\n"
      Link.all.each do |link|
        response += "*#{link.content}* - "
        response += ">Quant. Referencias: #{link.faqs.count}\n"
        response += "\n\n"
      end
      (Link.count > 0)? response : "Nada encontrado"
    end
  end
end
