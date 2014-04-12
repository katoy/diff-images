# -*- coding: utf-8 -*-
#
# ruby app.rb で動的にページ生成せずに、ページソースを保存して閲覧することも可能。
# その場合 この簡易サーバーを動作させるとよいです。
#

require 'rubygems'
require 'webrick'

include WEBrick

s = HTTPServer.new(
    # :port => 8000,
    :DocumentRoot => '.'
)

trap("INT") { s.shutdown }
s.start

