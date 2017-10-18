class InterpretService
  def self.call(action, params)
    case action
    when "list", "search", "search_by_hashtag"
      FaqModule::ListService.new(params, action).call
    when "create"
      FaqModule::CreateService.new(params).call
    when "remove"
      FaqModule::RemoveService.new(params).call
    when "list_links"
      FaqModule::ListLinksService.call
    when "highlight"
      FaqModule::HighlightService.new(params.merge("highlight" => true)).call
    when "unhighlight"
      FaqModule::HighlightService.new(params.merge("highlight" => false)).call
    when "help"
      HelpService.call
    else
      "Não compreendi seu desejo"
    end
  end
end
