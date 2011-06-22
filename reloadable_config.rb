require 'eventmachine'
require 'yaml'

class ReloadableConfig
  class Handler < EM::FileWatch
    def load_config
      $stderr.puts "Reload!"
      $config = YAML.load_file path
    end
    alias :file_modified :load_config
  end

  def run
    handler = EM.watch_file("config.yml", Handler)
    handler.load_config
  end
end

if $0 == __FILE__
  EM.run do
    ReloadableConfig.new.run
    EM.add_periodic_timer(5) { p $config }
  end
end
