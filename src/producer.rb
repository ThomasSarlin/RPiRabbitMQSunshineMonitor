require 'raspi-gpio'
require 'bunny'
require 'json'

begin
  pin = GPIO.new(4, IN)
rescue Exception => exception
  STDERR.puts exception.message
else
  puts "Connected to rPI"
ensure
  puts "Error connecting to rPI"
end

begin
  connection = Bunny.new
  connection.start
  channel = connection.create_channel
  queue = channel.queue('raspi-sunshine-monitor')
rescue Exception => exception
  STDERR.puts exception.message
else
  puts "Connected to RabbitMQ"
end

while true do
  value = defined? (pin) && pin.get_value || nil
  sunshine = defined? (value) && value > 20 || false
  puts('Sending sunshine data')
  channel.default_exchange.publish({value: value, sunshine: sunshine, date: Time.new.utc}.to_json, routing_key: queue.name)
  sleep(20)
end

connection.close
