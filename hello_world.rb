#!/usr/bin/env ruby
require 'rack'

class HelloWorld
  def call(env)
    [200,
      { "content-type" => "text/plain" },
      ["Hello World!\n"]]
  end
end

Rack::Handler::WEBrick.run(
  HelloWorld.new,
  :Port => 9000
)
