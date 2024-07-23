class AddMediaConvertJobIdToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :media_convert_job_id, :string
  end
end
