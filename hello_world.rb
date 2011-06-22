#!/usr/bin/env ruby
require 'goliath'

class HelloWorld < Goliath::API
  use Goliath::Rack::Validation::RequestMethod, %w(GET)

  def response(env)
    [200,
      { "content-type" => "text/plain" },
      ["Hello World!\n"]]
  end
end
