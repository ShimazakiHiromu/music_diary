require 'aws-sdk-s3'

class S3Uploader
  def self.upload(attachment, file_name)
    s3 = Aws::S3::Resource.new(region: 'ap-northeast-1')
    obj = s3.bucket('musicdiary-bucket').object("upload/#{file_name}")

    # ファイルを開いてS3にアップロード
    attachment.open do |file|
      obj.upload_file(file.path)
    end
    # アップロードが成功したかどうかを判断するロジックが必要
    # 以下は一例です。実際の条件に応じて適切な判定を追加してください。
    if obj.exists?
      return true, obj.key
    else
      return false, nil
    end
  end
end
