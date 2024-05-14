class AddArtistNameAndSongTitleToVideos < ActiveRecord::Migration[7.1]
  def change
    add_column :videos, :artist_name, :string
    add_column :videos, :song_title, :string
  end
end
