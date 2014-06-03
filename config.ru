require 'bundler/setup'
Bundler.require :default, :assets

require './app'

# use Rack::Session::Cookie,
#   key: 'rack.session',
#   domain: ENV['RACK_ENV'] == 'production' ? 'dojolist.herokuapp.com' : 'lvh.me',
#   path: '/',
#   expire_after: 86401,
#   secret: '1cWEv1o7KQAMAg59MGQoXN68M6c90fYq6R2OUGYZ2l7qFU5Qj8ysoi59L15i'
use Rack::Session::Cookie,
  key: 'rack.session',
  domain: 'dojolist.herokuapp.com',
  path: '/',
  expire_after: 86401,
  secret: '1cWEv1o7KQAMAg59MGQoXN68M6c90fYq6R2OUGYZ2l7qFU5Qj8ysoi59L15i'

use Rack::Deflater
run Sinatra::Application
