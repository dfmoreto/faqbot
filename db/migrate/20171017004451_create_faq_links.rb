class CreateFaqLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :faq_links do |t|
      t.references :faq, foreign_key: true
      t.references :link, foreign_key: true
    end
  end
end
