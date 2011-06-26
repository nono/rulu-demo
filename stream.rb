#!/usr/bin/env ruby

require 'goliath'

class Timer
  def initialize(port, config, status, logger)
    @chan = EM::Channel.new
    status[:timer] = @chan
  end

  def run
    EM.add_periodic_timer(1) do
      @chan << Time.now
    end
  end
end

class Stream < Goliath::API
  plugin Timer

  def response(env)
    timer = status[:timer]
    sid = timer.subscribe do |msg|
      env.stream_send("#{msg}\n")
    end
    EM.add_timer(10) do
      timer.unsubscribe sid
      env.stream_close
    end
    [200, {}, Goliath::Response::STREAMING]
  end
end
