#!/usr/bin/env ruby

require 'goliath'

class HelloWorld < Goliath::API
  def response(env)
    [200, {}, ["hello world!\n"]]
  end
end

class Router < Goliath::API
  map '/version' do
    run Proc.new do |env|
      [200, {"Content-Type" => "text/plain"}, ["v0.0.1"]]
    end
  end

  post "/secret" do
    run HelloWorld.new
  end

  get "/hello_world", HelloWorld

  map '/' do
    run Proc.new do |env|
      [404, {"Content-Type" => "text/html"}, ["Try /hello_world"]]
    end
  end
end
