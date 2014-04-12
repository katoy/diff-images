# -*- coding: utf-8 -*-

require 'rubygems'

require 'sinatra'
require 'sinatra/base'
require 'sinatra/reloader' # if development?

require 'haml'
require "pp"

set :public_folder, File.dirname(__FILE__) + '/public'
set :haml, format: :html5 # デフォルトのフォーマットは:xhtml

use Rack::CommonLogger

# Rack::Handler.register 'Webrick', 'Rack::Handler::WEBrick'

@@file_ary = []  # 全画像の名前 (数が多いので、この配列にスキャン結果をキャッシュする)

helpers do
  # file_path のファイル内容を得る。(utf8で)
  def get_textfile_contents_utf8(file_path)
    # Kconv.toutf8(open(file_path) {|f| f.read})
    open(file_path) { |f| f.read }
  rescue => e
    puts e.backtrace
    e.message
  end

  # href の link 記載用にエンコードする
  def get_encoded_url(url)
    # url は shift_jis,  html の encoding は utf-8.
    # windows 上、linix 上で ファイルパスに日本語が含まれているときはそれりの工夫が必要...

    # windows 上で ruby app.rb して、その画面ソースを保存して linux 上に置きたい時
    # Kconv.toutf8(url)

    # 通常 (windows 上で ruby app.rb したり、画面ソースを保存して、 windows 上に置きたい時)
    # URI.encode(url)
    url
  end

  # 画像ファイル (capture/, capture-prev/ 以下)の一覧を得る
  def get_file_list
    ans = []
    if @@file_ary.size == 0
      Dir.glob("public/results/capture/**/*.png").each do |f|
        name =  f[23..-1]
        ans << name
      end
      Dir.glob("public/results/capture-prev/**/*.png").each do |f|
        name =  f[28..-1]
        ans << name
      end
      Dir.glob("public/results/diff/**/*.png").each do |f|
        name = f[20..-1]
        ans << name
      end
      ans.uniq!
      @@file_ary = ans
    end
    @@file_ary
  end
end

# ========================================================
get '/' do
  haml :capture_diff
end

# for debug
get '/list' do

  s = ""
  get_file_list.each_with_index do|v, idx|
    s += "#{idx}: #{get_encoded_url(v)}<br/>"
  end
  s
end

get '/capture_diff' do
  redirect '/capture_diff.html'
end
get '/capture_diff.html' do
  haml :capture_diff
end

get '/capture_all' do
  redirect '/capture_all.html'
end
get '/capture_all.html' do
  haml :capture_all
end

get '/capture_logs' do
  redirect '/capture_logs.html'
end
get '/capture_logs.html' do
  haml :capture_logs
end

get '/slide_logs' do
  redirect '/slide_logs.html'
end
get '/slide_logs.html' do
  haml :slide_logs
end

get '/slide_diff' do
  redirect '/slide_diff.html'
end
get '/slide_diff.html' do
  haml :slide_diff
end

get '/slide_all' do
  redirect '/slide_all.html'
end
get '/slide_all.html' do
  haml :slide_all
end
#--- End of File ---
