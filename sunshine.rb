require 'raspio-gpio'
require 'bunny'


pin = GPIO.new(4, IN)

a = 0;
while a < 10
  sleep(5)
  puts pin.get_value
  a = a + 1
end
