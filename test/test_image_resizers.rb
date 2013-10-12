#!/usr/bin/env ruby

ENV['RACK_ENV'] = 'test'

TEST_ROOT = File.expand_path(File.dirname(__FILE__))
#Testing Dependancies
require "rubygems"
require "test/unit"
require "rack/test"

#App dependancies
require 'sinatra'
require "open-uri"
require "RMagick"

#App
require File.join(TEST_ROOT, "..", "app")

class ImageResizerTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    ImageResizer
  end

  def request_image url, width, height
    post '/', :image_url => url, :width => width, :height => height
  end

  def test_it_lives
    get '/'
    assert last_response.ok?
  end

  def test_valid_request
    request_image "http://s1.picdn.net/images/lohp/ss_logo.png", 50, 300
    assert last_response.ok?

    img = Magick::ImageList.new
    img.from_blob(last_response.body)
    assert_equal img.columns, 50
    assert_equal img.rows, 300
  end

  def test_missing_width
    request_image "http://s1.picdn.net/images/lohp/ss_logo.png", nil, 300
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

  def test_negative_width
    request_image "http://s1.picdn.net/images/lohp/ss_logo.png", -50, 300
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

  def test_zero_width
    request_image "http://s1.picdn.net/images/lohp/ss_logo.png", 50, 0
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

  def test_missing_height
    request_image "http://s1.picdn.net/images/lohp/ss_logo.png", 50, nil
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

  def test_negative_height
    request_image "http://s1.picdn.net/images/lohp/ss_logo.png", 50, -300
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

  def test_zero_height
    request_image "http://s1.picdn.net/images/lohp/ss_logo.png", 0, 300
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

  def test_missing_url
    request_image nil, 50, -300
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

  def test_invalid_url
    request_image "This is a fake URL", 50, -300
    assert_equal last_response.status, 500
    assert last_response.body.include? "ERROR"
  end

end
