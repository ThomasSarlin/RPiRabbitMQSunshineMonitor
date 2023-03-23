require './src/services/bunny-service.rb'
require './src/services/rpi-service.rb'

rabbitQueue = 'raspi-sunshine-monitor'
updateRate = 20 #How often would you like to recieve updates from the raspberry Pi (seconds)
bunnyService = BunnyService.new(rabbitQueue)
rpiService = RpiService.new

if !bunnyService.isActive || !rpiService.isActive
  puts 'One or more services are not active'
  exit
else
  puts 'Initializing service loop'
  while true do
    bunnyService.sendSunshineData(rpiService.getSunshineData)
    sleep(updateRate)
  end
  connection.close
end

