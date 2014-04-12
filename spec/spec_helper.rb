# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'

require 'coveralls'
require 'simplecov'
require 'simplecov-rcov'

set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

Coveralls.wear!

# simplecov, rcov, coderails の３通りの書式のレポートを生成する。
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
                                                           SimpleCov::Formatter::HTMLFormatter,
                                                           SimpleCov::Formatter::RcovFormatter,
                                                           Coveralls::SimpleCov::Formatter
                                                          ]
SimpleCov.start

