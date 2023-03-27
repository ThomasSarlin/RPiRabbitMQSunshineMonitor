require "bunny"
require "json"

class BunnyService
  def initialize(options)
    begin
      @connection = Bunny.new("amqp://#{options[:user]}:#{options[:password]}@#{options[:host]}")
      @connection.start
      @channel = @connection.create_channel
      @queue = @channel.queue(options[:queueName])
      @ttl = options[:ttl]
    rescue Exception => exception
      @connection = nil
      puts "-- Error connecting to RabbitMQ --"
      STDERR.puts exception.message
    else
      puts "-- Connected to RabbitMQ --"
    end
  end

  def isActive
    !@connection.nil?
  end

  def sendSunshineData(data)
    @channel.default_exchange.publish(data, {routing_key: @queue.name, :expiration => (@ttl.to_i * 1000).to_i})
  end

  def subscribeToQueue
    @queue.subscribe(manual_ack: true) do |delivery_info, metadata, payload|
      data = JSON.parse(payload)
      @channel.ack(delivery_info.delivery_tag)
      "It is currently #{data["sunshine"] ? "SUNNY" : "CLOUDY"} outside, with a temp of #{data["temp"]}C and humidity of #{data["humidity"]}"
    end
  end

  def close
    @connection.close
  end

  def consumeSunShineData
  end
end
