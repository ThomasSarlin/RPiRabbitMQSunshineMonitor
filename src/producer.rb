require './src/services/bunny-service.rb'
require './src/services/rpi-service.rb'

rabbitQueueName = 'raspi-sunshine-monitor'

#How often would you like to recieve updates from the raspberry Pi (seconds)
updateRate = 20
lightSensorInputPin = 4;
temperatureInputPin = nil;

#Initializing services.
bunnyService = BunnyService.new(rabbitQueueName)
rpiService = RpiService.new(lightSensorInputPin, temperatureInputPin)

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

