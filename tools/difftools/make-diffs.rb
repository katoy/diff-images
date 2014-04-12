# -*- coding: utf-8 -*-
require 'rubygems'
require 'rmagick'
require 'fileutils'
require 'tmpdir'
require 'benchmark'
require 'pp'
require 'pathname'
require 'progressbar'  # gem install progressbar

DIR_PREV = './captures-prev'
DIR_CUR  = './captures'
DIR_DIFF = './diffs'

def make_diff(dir_prev, dir_cur, dir_diff)
  return "ERROR: フォルダが存在していません。#{dir_prev}" unless File.exist?(dir_prev)
  return "ERROR: フォルダが存在していません。#{dir_cur}" unless File.exist?(dir_cur)

  total = 0
  # 画像総数を得る。
  # TODO: リファクタリング
  Dir.glob("#{dir_prev}/**/*").each do |f|
    total += 1 if f.end_with?('.png')
  end

  sames = diffs = 0
  diffs_name = []

  puts "ファイル総数： #{total}\n #{dir_prev} と #{dir_cur} の比較結果\n   -> #{dir_diff}"
  pbar = ProgressBar.new('diff', total, $stderr)

  tmp_dir = Dir.tmpdir
  work_cur = File.join(tmp_dir, 'work-cur.png')
  work_prev = File.join(tmp_dir, 'work-prev.png')
  work_diff = File.join(tmp_dir, 'work-diff.png')

  Dir.glob("#{dir_prev}/**/*.png").each do |f0|
    begin
      f1 = f0.gsub("#{dir_prev}/", "#{dir_cur}/")
      f2 = f0.gsub("#{dir_prev}/", "#{dir_diff}/")

      FileUtils.cp(f0, work_prev)
      FileUtils.cp(f1, work_cur)
      prev = Magick::Image.read(work_prev).first
      cure = Magick::Image.read(work_cur).first
      diff = prev.composite(cure, Magick::CenterGravity, Magick::DifferenceCompositeOp)
      # diff = diff.opaque('black', 'white')
      diff = diff.threshold(0.0)
      if diff.total_colors == 1
        sames += 1
      else
        diffs += 1
        diffs_name << f2
        diff.write(work_diff)
        to_dir = Pathname(f2).parent
        FileUtils.mkdir_p(to_dir) unless File.exist?(to_dir)
        FileUtils.cp(work_diff, f2)
      end
    rescue => e
      puts e
      # エラーがおこったら capture-prev の画像を diff 画像 として保存する。
      diffs += 1
      diffs_name << f2
      to_dir = Pathname(f2).parent
      FileUtils.mkdir_p(to_dir) unless File.exist?(to_dir)
      FileUtils.cp(work_prev, f2)
    end
    pbar.inc
  end

  pbar.finish

  ans = ''
  ans += diffs_name.join("\n") + "\n\n"
  ans += "変化あり: #{diffs} file(s)\n"
  ans += "変化なし: #{sames} file(s)\n"
  ans
end

# ------------------------------------------------
if __FILE__ == $PROGRAM_NAME
  def show_usage
    STDERR.puts('usage: ruby make-diffs src dest diff')
    STDERR.puts('  src/**/*.png と dest/**/*.png の差分画像を diff/**/*.png として出力します。')
    STDERR.puts("  defaiult 値： src = #{DIR_PREV}, dest = #{DIR_CUR}, diff = #{DIR_DIFF}")
  end

  if ARGV.size == 0
    show_usage
    exit 1
  end
  puts Benchmark::CAPTION
  puts Benchmark.measure {
    dir_prev = DIR_PREV
    dir_cur = DIR_CUR
    dir_diff = DIR_DIFF
    dir_prev = ARGV[0] if ARGV.size > 0
    dir_cur = ARGV[1] if ARGV.size > 1
    dir_diff = ARGV[2] if ARGV.size > 2
    ans = make_diff(File.expand_path(dir_prev), File.expand_path(dir_cur), File.expand_path(dir_diff))
    puts ans
  }
end
