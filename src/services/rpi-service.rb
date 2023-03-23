require 'raspi-gpio'
require 'json'


class RpiService
  def initialize
    begin
      @pin = GPIO.new(4, IN)
    rescue Exception => exception
      puts "---Error connecting to rPI---"
      @pin = nil
      STDERR.puts exception.message
    else
      puts "---Connected to rPI---"
    end
  end
  def isActive
    @pin.nil?
  end
  def getSunshineData
    value = defined? (@pin) && @pin.get_value || nil
    sunshine = defined? (value) && value > 20 || false

    {value: value, sunshine: sunshine, date: Time.new.utc}.to_json
  end
end
