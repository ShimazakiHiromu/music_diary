class CreateVideos < ActiveRecord::Migration[7.1]
  def change
    create_table :videos do |t|
      t.references :diary, null: false, foreign_key: true
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
