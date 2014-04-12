# -*- coding: utf-8 -*-
# 2012-05-31 katoy
# Imagemagick の compare コマンドとほぼ同様な機能 (Imagemagick をしらべていて compare に気がついた orz..)
# convert とは差分画像の形式が異なる。
# 日本語ファイル名も扱える。
#

require 'rubygems'
require 'rmagick'
require 'fileutils'
require 'tmpdir'
require 'pp'
require 'pathname'

def compare_images(file_0, file_1, file_diff = nil)
  ans = false
  [file_0, file_1].each do |f|
    unless File.exist?(f)
      STDERR.puts("ERROR: ファイルが存在していません。ファイル名：'#{f}'")
      return ans
    end
  end

  # imagemagic が日本語ファイル名をあつかえない ? ようなので、一時ファイルに copy して作業する。
  work_0 = work_1 = work_diff = nil

  begin
    tmp_dir = Dir.tmpdir
    work_0 = File.join(tmp_dir, 'work-0')
    work_1 = File.join(tmp_dir, 'work-1')
    ext = '.png'
    ext = Pathname.new(file_diff).extname if file_diff
    work_diff = File.join(tmp_dir, 'work-diff' + ext)

    FileUtils.cp(file_0, work_0)
    FileUtils.cp(file_1, work_1)
    data_0 = Magick::Image.read(work_0).first
    data_1 = Magick::Image.read(work_1).first

    diff = data_0.composite(data_1, Magick::CenterGravity, Magick::DifferenceCompositeOp)
    # diff = diff.opaque('black', 'white')
    diff = diff.threshold(0.0)
    if diff.total_colors == 1
      ans = true
    else
      if file_diff
        diff.write(work_diff)
        to_dir = Pathname(file_diff).parent
        FileUtils.mkdir_p(toDir) unless File.exist?(to_dir)
        FileUtils.cp(work_diff, file_diff)
      end
    end
  rescue => e
    STDERR.puts e.backtrace
    STDERR.puts e
    # エラーがおこったら file_0 を diff 画像 とする。
    # TODO: file_0 がエラーの原因だったときのことを考慮すること。
    to_dir = Pathname(file_diff).parent
    FileUtils.mkdir_p(toDir) unless File.exist?(to_dir)
    FileUtils.cp(file_0, file_diff)
  ensure
    # 一時ファイルを削除する
    FileUtils.rm(work_0,    force: true)
    FileUtils.rm(work_1,    force: true)
    FileUtils.rm(work_diff, force: true)
  end

  ans
end

# ------------------------------------------------
if __FILE__ == $PROGRAM_NAME
  def show_usage
    STDERR.puts('usage: ruby compare-images.rb image_0 image_1 [image_diff]')
    STDERR.puts(' output:')
    STDERR.puts('      "true": 画像は一致')
    STDERR.puts('      "false": 画像は不一致')
    STDERR.puts(' iamge_0, image_1: 比較する画像ファイル。両者の画像データ形式が異なっていても OK。')
    STDERR.puts('       image_diff: 画像の差分。指定した拡張子に従ったデータ形式で出力される。')
    STDERR.puts('                   default 値は ./diff.png')
  end

  if ARGV.size < 2
    show_usage
    exit(1)
  end

  file_diff = 'diff.png'

  file_0 = ARGV[0]
  file_1 = ARGV[1]
  file_diff = ARGV[2]  if ARGV.size > 2

  ans = compare_images(File.expand_path(file_0), File.expand_path(file_1), File.expand_path(file_diff))
  print ans
end
# --- End of File ---
