#!/usr/bin/env ruby
#
# Simple example that takes all GET requests and forwards
# them to another API using em-http-request. It can slow
# down some request, based on their content-types. You can
# use it to see the effect of slow loading of JS files for
# example.
#
require 'goliath'
require 'em-http'
require 'em-synchrony'
require 'em-synchrony/em-http'
require './reloadable_config'


class SlowHttp < Goliath::API
  use Goliath::Rack::Validation::RequestMethod, %w(GET)
  use Goliath::Rack::Params
  plugin ReloadableConfig

  def on_headers(env, headers)
    env['client-headers'] = headers
  end

  def response(env)
    url    = "http://#{$config['host']}#{env[Goliath::Request::REQUEST_PATH]}"
    params = { head: env['client-headers'], query: env.params }
    http   = EM::HttpRequest.new(url).get(params)

    ctype  = http.response_header[Goliath::Request::CONTENT_TYPE]
    delay  = $config[ctype]
    EM::Synchrony.sleep(delay) if delay

    headers = to_http_headers(http.response_header)
    [http.response_header.status, headers, http.response]
  end

  # Need to convert from the CONTENT_TYPE we'll get back from the server
  # to the normal Content-Type header
  def to_http_headers(response_header)
    headers = {}
    response_header.each_pair do |k, v|
      h = k.downcase.split('_').collect { |e| e.capitalize }.join('-')
      headers[h] = v
    end
    headers
  end
end
