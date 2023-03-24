require 'raspi-gpio'
require 'json'
require 'rpi/dht'

class RpiService
  def initialize (lightSensorInputPin = nil, tempIOPin = nil)
    begin
      @tempreaturePin = tempIOPin
      @lightSensorPin = defined?(lightSensorInputPin) && GPIO.new(lightSensorInputPin, IN) || nil
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
    #tempValue format is {temperature: number, humidity: number, temperature_f: number}
    tempValue = defined? (@tempreaturePin) && RPi::Dht.read_22(@temperaturePin)|| nil

    #returns 1 if ambient light level is above set physical threshold of lightSensor
    lightSensorValue = defined? (@lightSensorPin) && @lightSensorPin.get_value || nil

    {lightSensorValue: lightSensorValue, tempuratureValue: temperatureValue, date: Time.new.utc}.to_json
  end
end
