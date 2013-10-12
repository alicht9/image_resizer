require 'rubygems'
require "bundler"
require 'sinatra'
require "open-uri"
require "RMagick"
require './app.rb'

run ImageResizer.new
