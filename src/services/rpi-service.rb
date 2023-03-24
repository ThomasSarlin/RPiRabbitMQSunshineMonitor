require 'raspi-gpio'
require 'json'
require "pathname"

def read_humidity
  Pathname("/sys/bus/iio/devices/iio\:device0/in_humidityrelative_input").read.to_f / 1000
rescue => ex
  sleep 0.25
  retry
end

def read_temperature
  Pathname("/sys/bus/iio/devices/iio\:device0/in_temp_input").read.to_f / 1000
rescue => ex
  sleep 0.25
  retry
end

class RpiService
  def initialize (options)
    begin
      @tempreaturePin = options[:tempSensorPin]
      @lightSensorPin = defined?(options[:lightSensorPin]) && GPIO.new(options[:lightSensorPin], IN) || nil
    rescue Exception => exception
      puts "---Error connecting to rPI---"
      @tempreaturePin = nil
      @lightSensorPin = nil
      STDERR.puts exception.message
    else
      puts "---Connected to rPI---"
      if !@temperaturePin.nil? && defined?(RPi::Dht.read_22(@temperaturePin))
        puts "-- TemperaturePin established -- "
      end
      if !@lightSensorPin.nil? && defined?(@temperaturePin.get_value)
        puts "-- TemperaturePin established -- "
      end
    end
  end

  def isActive
    !@lightSensorPin.nil? || !@tempreaturePin.nil?
  end

  def getSunshineData
    temp = read_temperature
    humitidy = read_humidity
    #returns 1 if ambient light level is above set physical threshold of lightSensor
    lightSensorValue = defined? (@lightSensorPin) && @lightSensorPin.get_value || nil

    {lightSensorValue: lightSensorValue, temp: temp, humitidy: humitidy, date: Time.new.utc}.to_json
  end

end
