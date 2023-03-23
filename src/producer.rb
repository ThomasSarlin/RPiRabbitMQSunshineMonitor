require './src/services/bunny-service.rb'
require './src/services/rpi-service.rb'

rabbitQueue = 'raspi-sunshine-monitor'
bunnyService = BunnyService.new(rabbitQueue)
rpiService = RpiService.new

if !bunnyService.isActive || !rpiService.isActive
  puts 'One or more services as not not active'
  exit
else
  puts 'Initializing service loop'
  while true do
    BunnyService.sendSunshineData(rpiService.getSunshineData)
    sleep(20)
  end
  connection.close
end

