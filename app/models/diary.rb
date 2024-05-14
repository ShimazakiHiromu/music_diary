class Diary < ApplicationRecord
  belongs_to :user
  has_many :videos, dependent: :destroy

  # 動画ファイルがアップロードされていない場合にデータを無視
  accepts_nested_attributes_for :videos, reject_if: proc { |attributes| attributes['video_file'].blank? }, allow_destroy: true

  validates :date, presence: true, uniqueness: { scope: :user_id }
  validates :content, presence: true
end
