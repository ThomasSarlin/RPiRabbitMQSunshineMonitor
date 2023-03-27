require './src/services/bunny-service.rb'
require 'terminal-notifier'

class Subscriber
  def initialize(options)
    @bunnyService = BunnyService.new(options)
  end
  def run
    if !@bunnyService.isActive
      puts 'Unable to connect to RabbitMQ, shutting down'
      exit
    else
      puts 'Initializing subscriber loop'
      Thread.new do
        info = @bunnyService.subscribeToQueue
        TerminalNotifier.notify(info)
        loop do sleep(0.25) until $exit_app
        end
        @bunnyService.close
      end
    end
  end
end

