# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'

describe 'App' do
  include Rack::Test::Methods
  def app
    @app ||= Sinatra::Application
  end

  describe 'レスポンスの精査' do
    describe '/へのアクセス' do
      before { get '/' }
      it '正常なレスポンスが返ること' do
        last_response.should be_ok
      end
      it 'キャプチャーの比較 が出力されていること' do
        last_response.body.should include('キャプチャーの比較')
      end
    end
  end
end
