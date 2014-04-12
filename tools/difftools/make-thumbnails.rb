# -*- coding: utf-8 -*-

require 'rubygems'
require 'rmagick'
require 'fileutils'
require 'tmpdir'
require 'benchmark'
require 'pp'
require 'progressbar'  # gem install progressbar

def make_thumbnail(src, dest, image_size)
  return "ERROR: フォルダが存在していません。#{src}" unless File.exist?(src)

  total = 0
  # 出力フォルダーの階層を作る
  # TODO: リファクタリング
  Dir.glob(src + '/**/*').each do |f|
    if File.ftype(f) == "directory"
      to_dir = f.gsub(src, dest)
      FileUtils.mkdir_p(to_dir) unless File.exist?(to_dir)
      # puts to_dir
    end
    total += 1 if f.end_with?(".png")
  end

  puts " #{total}ファイル:  #{src} -> #{dest}"
  pbar = ProgressBar.new('thumbnail', total, $stderr)

  count = 0
  tmp_dir = Dir.tmpdir
  work_0 = File.join(tmp_dir, 'work-0.png')
  work_1 = File.join(tmp_dir, 'work-1.png')

  Dir.glob(src + '/**/*.png').each do |f|
    begin

      FileUtils.cp(f, work_0)
      image = Magick::Image.read(work_0).first
      image.resize_to_fill(image_size).write(work_1)

      to_name = f.gsub(src, dest)
      FileUtils.cp(work_1, to_name)
      count += 1
    rescue => e
      puts e
    end
    pbar.inc
  end
  pbar.finish
  " #{count}ファイルのサムネイルを作成しました。"
end

if __FILE__ == $PROGRAM_NAME
  def show_usage
    STDERR.puts('usage: ruby make-thmbnaols.rb src dest [size]')
    STDERR.puts('  src/**/*.png のサムナイルを dest/**/*.png として出力します。')
    STDERR.puts('  size: サムネイルのサイズ. default = 120')
  end
  if ARGV.size <= 1 || ARGV.size >= 4
    show_usage
    exit 1
  end

  puts Benchmark::CAPTION
  puts Benchmark.measure {
    src = ARGV[0]
    dest = ARGV[1]
    image_size = 120
    image_size = ARGV[2].to_i if ARGV.size == 3
    if image_size <= 0
      STDERR.puts("illegal size value: #{image_size}")
      exit 1
    end
    puts make_thumbnail(File.expand_path(src), File.expand_path(dest), image_size)
  }
end
