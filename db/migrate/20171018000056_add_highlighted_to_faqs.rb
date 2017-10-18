class AddHighlightedToFaqs < ActiveRecord::Migration[5.1]
  def change
    add_column :faqs, :highlighted, :boolean, default: false
  end
end
