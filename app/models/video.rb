class Video < ApplicationRecord
  belongs_to :diary
  has_one_attached :video_file
  
  enum status: { practicing: 0, completed: 1, daily_routine: 2 }
  enum conversion_status: { pending: 0, processing: 1, converted: 2 }

  def converted?
    conversion_status == 'converted'
  end
end
