class Video < ApplicationRecord
  belongs_to :diary
  has_one_attached :video_file
  
  enum status: { practicing: 0, completed: 1, daily_routine: 2 }

  def converted?
    video_file.content_type == 'video/mp4'
  end
end
