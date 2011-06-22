#!/usr/bin/env ruby
require 'goliath'
require 'em-http'
require 'em-synchrony/em-http'


class SlowHttp < Goliath::API
  use Goliath::Rack::Validation::RequestMethod, %w(GET)
  use Goliath::Rack::Params

  def on_headers(env, headers)
    env['client-headers'] = headers
  end

  def response(env)
    url    = "http://localhost:3000#{env[Goliath::Request::REQUEST_PATH]}"
    params = { head: env['client-headers'], query: env.params }
    http   = EM::HttpRequest.new(url).get(params)

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
