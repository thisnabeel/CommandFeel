class AddFieldsToPhraseLinks < ActiveRecord::Migration[7.0]
  def change
    add_column :phrase_links, :title, :string
    add_column :phrase_links, :explanation, :text
    add_column :phrase_links, :category, :string
    
    # Make phrasable polymorphic association optional
    change_column_null :phrase_links, :phrasable_type, true
    change_column_null :phrase_links, :phrasable_id, true
  end
end 