# RPiRabbitMQSunshineMonitor
Simple Raspberry pi light-sensor implementation which adds sunshine messages onto a rabbitMQ queue to be consumed.


### Setup DHT-11/22
1. edit /boot/config on your Raspberry Pi
1. add `dtoverlay=dht11` at the bottom
