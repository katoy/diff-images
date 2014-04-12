# -*- coding: utf-8 -*-
require 'rubygems'
require 'rmagick'
require 'fileutils'
require 'tmpdir'
require 'benchmark'
require 'pp'
require 'progressbar'  # gem install progressbar

def bmp2png(src)
  return "ERROR: フォルダが存在していません。#{src}" unless File.exist?(src)
  return "ERROR: フォルダを指定してください。#{src}" unless File.exist?(src)

  total = 0
  # 対象ファイルをカウントする
  # TODO: リファクタリング
  Dir.glob(src + '/**/*.bmp').each do |f|
    total += 1
  end

  pbar = ProgressBar.new('bmp2png', total, $stderr)

  count = 0
  tmp_dir = Dir.tmpdir
  work_bmp = File.join(tmp_dir, 'work.bmp')
  work_png = File.join(tmp_dir, 'work.png')
  Dir.glob(src + '/**/*.bmp').each do |f|
    begin
      FileUtils.cp(f, work_bmp)
      image = Magick::Image.read(work_bmp).first
      image.write(work_png)

      to_name = f.sub(/\.bmp$/, '.png')
      FileUtils.cp(work_png, to_name)
      FileUtils.rm(f)
      # puts f
      count += 1
    rescue => e
      puts e
    end
    pbar.inc
  end
  pbar.finish
  " #{count}ファイルを PNG に変換しました。"
end

if __FILE__ == $PROGRAM_NAME

  def show_usage
    STDERR.puts('usage: ruby bmp2png dir')
    STDERR.puts('  dir/**/*.bmp を png に変換します。')
  end

  puts Benchmark::CAPTION
  puts Benchmark.measure {
    if ARGV.size == 0
      show_usage
      exit 1
    else
      puts bmp2png(File.expand_path(ARGV[0]))
    end
  }
end
