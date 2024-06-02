class VideoConverterJob < ApplicationJob
  queue_as :default

  def perform(video)
    return unless video.video_file.attached?

    # 動画ファイルのパスを取得
    path_to_original = ActiveStorage::Blob.service.path_for(video.video_file.key)
    path_to_converted = "#{path_to_original}.mp4".sub(/\.\w+$/, ".mp4")  # Ensure the filename ends with .mp4

    # ffmpegを使用して動画を変換
    if system "ffmpeg -i #{Shellwords.escape(path_to_original)} -vcodec h264 -acodec aac #{Shellwords.escape(path_to_converted)} > conversion.log 2>&1"
      # 変換後のファイルをアタッチ
      video.video_file.attach(
        io: File.open(path_to_converted),
        filename: "#{video.video_file.filename.base}.mp4",
        content_type: 'video/mp4'  # 修正箇所
      )
      # ステータスを 'converted' に更新
      video.update(conversion_status: 'converted')
      # 元のMOVファイルを削除
      File.delete(path_to_original) if File.exist?(path_to_original)
    else
      # 変換失敗のログを記録
      Rails.logger.error "Failed to convert video: #{video.id}"
      Rails.logger.error "FFmpeg Error: #{File.read('conversion.txt')}"
    end
  end
end
