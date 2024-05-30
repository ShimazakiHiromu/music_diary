class VideoConverterJob < ApplicationJob
  queue_as :default

  def perform(video)
    return unless video.video_file.attached?

    # 動画ファイルのパスを取得
    path_to_original = ActiveStorage::Blob.service.path_for(video.video_file.key)
    path_to_converted = path_to_original.sub(/\.\w+$/, ".mp4")

    # ffmpegを使用して動画を変換
    system "ffmpeg -i #{path_to_original} -vcodec h264 -acodec aac #{path_to_converted}"

    # 変換後のファイルをアタッチ
    video.video_file.attach(
      io: File.open(path_to_converted),
      filename: video.video_file.filename.base + ".mp4",
      content_type: 'video/mp4'
    )

    # 元のMOVファイルを削除
    File.delete(path_to_original) if File.exist?(path_to_original)
  end
end
