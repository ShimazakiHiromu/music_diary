class AddJobIdToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :job_id, :string
    add_index :videos, :job_id, unique: true
  end
end