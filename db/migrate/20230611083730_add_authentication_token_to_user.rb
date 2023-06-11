class AddAuthenticationTokenToUser < ActiveRecord::Migration[7.0]
  def change

    change_table(:users) do |t|
      ## Required
      t.string :provider, :null => false, :default => "email"
      t.string :uid, :null => false, :default => ""

      ## Tokens
      t.json :tokens

    end

    add_column :users, :authentication_token, :string, limit: 30
    add_index :users, :authentication_token, unique: true

  end
end
