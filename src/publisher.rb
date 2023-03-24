require './src/services/bunny-service.rb'
require './src/services/rpi-service.rb'

class Publisher
  def initialize(options)
    @updateRate = options[:updateRate]
    @bunnyService = BunnyService.new(options)
    @rpiService = RpiService.new(options)
  end
  def run
    if !@bunnyService.isActive
      puts 'Unable to connect to RabbitMQ, shutting down'
      exit
    elsif !@rpiService.isActive
      puts 'No active rPi services, shutting down'
    exit
    else
      puts 'Initializing service loop'
      while true do
        @bunnyService.sendSunshineData(@rpiService.getSunshineData)
        sleep(@updateRate)
      end
      @bunnyService.close
    end
  end
end

