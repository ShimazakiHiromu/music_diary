require 'aws-sdk-s3'

class S3Uploader
  # diary_id と video_id を追加
  def self.upload(attachment, file_name, diary_id, video_id)
    s3 = Aws::S3::Resource.new(region: 'ap-northeast-1')
    # パスに diary_id と video_id を含める
    obj = s3.bucket('musicdiary-bucket').object("diaries/#{diary_id}/videos/#{video_id}/#{file_name}")

    # ファイルを開いてS3にアップロード
    attachment.open do |file|
      obj.upload_file(file.path)
    end
    # アップロードが成功したかどうかを判断するロジックが必要
    if obj.exists?
      return true, obj.key
    else
      return false, nil
    end
  end
end
