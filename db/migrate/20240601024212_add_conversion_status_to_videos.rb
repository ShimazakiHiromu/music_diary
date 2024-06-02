class AddConversionStatusToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :conversion_status, :integer, default: 0
  end
end
