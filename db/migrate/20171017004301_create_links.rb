class CreateLinks < ActiveRecord::Migration[5.1]
  def change
    create_table :links do |t|
      t.string :content
      t.references :company, foreign_key: true
    end
  end
end
