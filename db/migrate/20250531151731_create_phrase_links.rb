class CreatePhraseLinks < ActiveRecord::Migration[7.0]
  def change
    create_table :phrase_links do |t|
      t.references :phrasable, polymorphic: true, null: false
      t.references :phrase, null: false, foreign_key: true

      t.timestamps
    end

    add_index :phrase_links, [:phrasable_type, :phrasable_id, :phrase_id], unique: true, name: 'index_phrase_links_on_phrasable_and_phrase'
  end
end 