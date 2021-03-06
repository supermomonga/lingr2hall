# coding: utf-8

require 'bundler'
Bundler.require
require 'sinatra/reloader' if development?
require 'net/http'
require 'json'


class Message

  def initialize title, message, picture = nil
    @title = title
    @message = message
    @picture = picture
  end

  def to_json
    {
      title: @title,
      message: @message,
      picture: @picture ? @picture : ''
    }.to_json
  end

end


class HallClient

  def self.post group_api_key, title, body, picture
    Thread.start {
      mes = Message.new title, body, picture
      uri = URI.parse "https://hall.com/api/1/services/generic/#{group_api_key}"

      req = Net::HTTP::Post.new uri.request_uri, initheader = {'Content-Type' =>'application/json'}
      req.body = mes.to_json

      http = Net::HTTP.new uri.host, uri.port
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      http.set_debug_output $stderr

      http.start do |h|
        res = h.request req
        p res
      end
    }
  end
end


get '/' do
  return 'hi'
end

post '/post' do
  body = request.body.read
  return '' unless body
  return '' if body == ''
  data = JSON.parse body
  p data
  data['events'].map do |event|
    message = event['message']
    room_id = message['room']
    text    = message['text']
    icon    = message['icon_url']
    speaker = message['nickname']

    # Prepare
    title   = "#{speaker} (at Lingr)"
    body    = text
    picture = icon

    group_api_key = ENV["ROOM_#{room_id.upcase}"]

    return '' unless group_api_key

    # Post
    HallClient.post group_api_key, title, body, picture

    return ''
  end
end


