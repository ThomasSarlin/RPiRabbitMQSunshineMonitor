require 'bunny'

class BunnyService
  def initialize(options)
    begin
      @connection = Bunny.new(options[:url])
      @connection.start
      @channel = @connection.create_channel
      @queue = @channel.queue(options[:queueName])
    rescue Exception => exception
      @connection = nil
      puts "---Error connecting to RabbitMQ---"
      STDERR.puts exception.message
    else
      puts "---Connected to RabbitMQ---"
    end
  end
  def isActive
    @connection.nil?
  end
  def sendSunshineData(data)
    @channel.default_exchange.publish(data, routing_key: @queue.name)
  end
  def close
    @connection.close
  end
  def consumeSunShineData
  end
end
