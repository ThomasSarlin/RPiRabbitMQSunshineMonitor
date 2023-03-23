require 'raspi-gpio'
require 'json'


class RpiService
  def initialize (lightSensorInputPin = nil, tempInputPin = nil)
    begin
      @tempreaturePin = defined?(tempInputPin) && GPIO.new(tempInputPin, IN) || nil
      @lightSensorPin = defined?(lightSensorInputPin) && GPIO.new(lightSensorInputPin, IN) || nil
    rescue Exception => exception
      puts "---Error connecting to rPI---"
      @tempreaturePin = nil
      @lightSensorPin = nil
      STDERR.puts exception.message
    else
      puts "---Connected to rPI---"
    end
  end
  def isActive
    !@lightSensorPin.nil? || !@tempreaturePin.nil?
  end
  def getSunshineData
    tempValue = defined? (@tempreaturePin) && @tempreaturePin.get_value || nil
    lightSensorValue = defined? (@lightSensorPin) && @lightSensorPin.get_value || nil

    {lightSensorValue: lightSensorValue, tempuratureValue: temperatureValue, date: Time.new.utc}.to_json
  end
end
