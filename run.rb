require "optparse"
require "./src/publisher.rb"
require "./src/subscriber.rb"

options = {}
options[:publisher] = false
options[:updateRate] =  20
options[:lightSensorPin] =  3
options[:user]='guest'
options[:password]='guest'
options[:queueName] = 'raspi-sunshine-monitor'
options[:host] = 'localhost'
$exit_app = false;
OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

  opts.on("-p", "--publisher", "Run as publisher") do |v|
    options[:publisher] = true
  end
  opts.on("-U", "--user=USER", "Set username") do |u|
    options[:user] = u
  end
  opts.on("-P", "--password=PASSWORD", "Set password for user") do |p|
    options[:password] = p
  end
  opts.on("-D", "--use-dht", "Activate DHT-11/22 sensor") do |dht|
    options[:dht] = true
  end
  opts.on("-l", "--use-lightsensor", "Activate lightsensor") do |ls|
    options[:lightsensor] = true
  end
  opts.on("-L", "--lightsensor-pin=SENSORPIN", "Set light-sensor-pin, default 3") do |l|
    options[:lightSensorPin] =  l
  end
  opts.on("-u", "--update-rate=UPDATERATE", "Set update-rate of publisher thread") do |u|
    puts u
    options[:updateRate] =  u.to_i
  end
  opts.on("-q", "--queue-name=QUEUENAME", "Set queue name") do |q|
    options[:lightSensorPin] =  q
  end
  opts.on("-H", "--host=HOST", "Set rabbit-mq host url") do |h|
    options[:host] =  h
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!



if (options[:publisher])
  publisher = Publisher.new(options)
  publisher.run
else
  subscrber = Subscriber.new(options)
  subscrber.run
end



puts '[-------------------------------------------------]'
puts '[-------------------------------------------------]'
puts '[-------------- Press enter to exit --------------]'
puts '[-------------------------------------------------]'
puts '[-------------------------------------------------]'
if (gets.chomp == "r")
 $exit_app = true
end
