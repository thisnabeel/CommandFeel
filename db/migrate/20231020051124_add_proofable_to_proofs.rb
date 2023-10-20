class AddProofableToProofs < ActiveRecord::Migration[7.0]
  def change
    add_column :proofs, :proofable_id, :integer
    add_column :proofs, :proofable_type, :string
  end
end
