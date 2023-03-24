require "optparse"
require "./src/publisher.rb"

options = {}
options[:publisher] = false
options[:updateRate] =  20
options[:lightSensorPin] =  3
options[:tempSensorPin] =  4
options[:user]='guest'
options[:password]='guest'
options[:queueName] = 'raspi-sunshine-monitor'
options[:host] = 'localhost'

OptionParser.new do |opts|
  opts.banner = "Usage: run.rb [options]"

  opts.on("-p", "--publisher", "Run as publisher") do |v|
    options[:publisher] = true
  end
  opts.on("-P", "--password", "Run as publisher") do |p|
    options[:password] = p
  end
  opts.on("-U", "--user", "Run as publisher") do |u|
    options[:user] = u
  end
  opts.on("-u", "--update-rate", "Set update-rate of publisher thread") do |u|
    options[:updateRate] =  u
  end
  opts.on("-l", "--light-sensor-pin", "Set temp-sensor-pin") do |l|
    options[:lightSensorPin] =  l
  end
  opts.on("-q", "--queue-name", "Set queue name") do |q|
    options[:lightSensorPin] =  q
  end
  opts.on("-t", "--temp-sensor-pin", "Set light-sensor-pin") do |t|
    options[:tempSensorPin] =  t
  end
  opts.on("-h", "--host", "Set rabbit-mq host url") do |h|
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
end

