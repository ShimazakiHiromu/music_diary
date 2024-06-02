class VideoConverterJob < ApplicationJob
  queue_as :default

  def perform(video)
    return unless video.video_file.attached?

    # ダウンロードして一時ファイルに保存
    tempfile = Tempfile.new(["video", ".#{video.video_file.filename.extension}"], binmode: true)
    video.video_file.download { |chunk| tempfile.write(chunk.force_encoding("ASCII-8BIT")) }
    tempfile.close

    path_to_converted = "#{tempfile.path}.mp4"

    # ffmpegを使用して動画を変換
    if system "ffmpeg -i #{Shellwords.escape(tempfile.path)} -vcodec h264 -acodec aac #{Shellwords.escape(path_to_converted)}"
      # 変換後のファイルをアタッチ
      File.open(path_to_converted, 'rb') do |file|
        video.video_file.attach(
          io: file,
          filename: "#{video.video_file.filename.base}.mp4",
          content_type: 'video/mp4'
        )
      end
      # ステータスを 'converted' に更新
      video.update(conversion_status: 'converted')
    else
      # 変換失敗のログを記録（方法はエラーハンドリングに依存）
      Rails.logger.error "Failed to convert video: #{video.id}"
      # ここにFFmpegのエラー内容を記録する方法を追加
    end

    # 一時ファイルの削除
    tempfile.unlink
    File.delete(path_to_converted) if File.exist?(path_to_converted)
  end
end
