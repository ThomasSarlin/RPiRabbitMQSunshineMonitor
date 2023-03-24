require './src/services/bunny-service.rb'
require './src/services/rpi-service.rb'

class Publisher
  def initialize(options)
    @updateRate = options[:updateRate]
    @bunnyService = BunnyService.new(options)
    @rpiService = RpiService.new(options)
  end
  def run
    if !@bunnyService.isActive || !@rpiService.isActive
      puts 'One or more services are not active'
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

