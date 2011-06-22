#!/usr/bin/env ruby
require 'rack'

class HelloWorld
  def call(env)
    [200,
      { "content-type" => "text/plain" },
      ["Hello World!\n"]]
  end
end

class RequestMethod
  def initialize(app)
    @app = app
  end

  def call(env)
    if env["REQUEST_METHOD"] == "GET"
      @app.call(env)
    else
      [405, {}, ["Method not allowed\n"]]
    end
  end
end

app = HelloWorld.new
app = RequestMethod.new(app)

Rack::Handler::WEBrick.run(
  app,
  :Port => 9000
)
