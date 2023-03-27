
require "json"

class MockPi
  def isActive
    true
  end

  def getSunshineData
    { sunshine: true, temp: 25,humitidy: 50, date: Time.new.utc}.to_json
  end
end
