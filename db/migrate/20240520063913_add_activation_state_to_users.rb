class AddActivationStateToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :activation_state, :string, default: nil
    add_index :users, :activation_token
  end
end
