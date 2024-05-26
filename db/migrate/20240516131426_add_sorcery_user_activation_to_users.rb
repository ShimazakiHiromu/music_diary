class AddSorceryUserActivationToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :activation_token, :string
    add_column :users, :activation_token_expires_at, :datetime
    add_column :users, :activated_at, :datetime
  end
end
