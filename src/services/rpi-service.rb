require "raspi-gpio"
require "json"
require "pathname"

class RpiService
  def initialize(options)
    @dhtActive = options[:dht]
    @lsActive = options[:lightsensor]
    @ttl = options[:ttl]

    if @dhtActive && read_temperature != nil
      puts "-- DHT connected -- "
    elsif @dhtActive
      puts "-- Error reading DHT --"
      @dhtActive = false
    end

    if @lsActive
      begin
        @lightSensorPin = @lsActive && defined?(options[:lightSensorPin]) &&GPIO.new(options[:lightSensorPin], IN) || nil

      rescue => exception
        puts "-- Error reading GPIO on pin #{options[:lightSensorPin]} --"
        @lsActive = false
        STDERR.puts exception.message

      else
        if !@lightSensorPin.nil? && defined?(@lightSensorPin.get_value)
          puts "-- LightSensor connected -- "

        else
          puts "-- LightSensor inactive, unable to get_value from pin #{optins[:lightSensorPin]} --"
          @lsActive = false
        end
      end

    end

  end

  def isActive
    @dhtActive || @lsActive
  end

  def getSunshineData
    temp = @dhtActive && read_temperature || nil
    humidity = @dhtActive && read_humidity || nil

    #returns 1 if ambient light level is above set physical threshold of lightSensor
    lightSensorValue = @lsActive && defined?(@lightSensorPin) && @lightSensorPin.get_value || nil
    { sunshine: lightSensorValue.to_i == LOW, temp: temp,humitidy: humidity, date: Time.new.utc}.to_json
  end
end


=begin
  Humilty and temp are read from the i/o files for the dht device,
  it sometimes fails so we have to re-attempt in case of failue to read file when it's rewritten by the dht-sensor
=end

def read_humidity
  attempts ||= 1
  Pathname("/sys/bus/iio/devices/iio\:device0/in_humidityrelative_input").read.to_f / 1000
rescue
  sleep 0.25
  if (attempts += 1) < 10
    retry
  else
    nil
  end
end

def read_temperature
  attempts ||= 1
  Pathname("/sys/bus/iio/devices/iio\:device0/in_temp_input").read.to_f / 1000
rescue
  sleep 0.25
  if (attempts += 1) < 10
    retry
  else
    nil
  end
end
