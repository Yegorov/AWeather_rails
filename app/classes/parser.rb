require 'net/http'

class Parser
  @@direction = {
                  "0"  => "South",
                  "1"  => "Southwest",
                  "2"  => "Southwest",
                  "3"  => "Southwest",
                  "4"  => "West",
                  "5"  => "Northwest",
                  "6"  => "Northwest",
                  "7"  => "Northwest",
                  "8"  => "North",
                  "9"  => "Northeast",
                  "10" => "Northeast",
                  "11" => "Northeast",
                  "12" => "East",
                  "13" => "Southeast",
                  "14" => "Southeast"
                }
  def self.parse
    res = Net::HTTP.get_response(URI('http://inmart.ua/android_weather.php'))
    weather = { "temp" => 'unknown', 
                "bar" =>  'unknown',
                "humidity" => 'unknown',
                "wind_s" => 'unknown',
                "wind_d" => 'unknown'
            }
    case res
    when Net::HTTPSuccess
      w = res.body.split("~")
      weather[:temp] = w[2]
      weather[:bar] = w[1]
      weather[:humidity] = w[0]
      weather[:wind_s] = w[3]
      weather[:wind_d] = @@direction.has_key?(w[4]) ? @@direction[w[4]] : 'unknown'
    end  
    weather
  end
end
#class WetherParser
#  def initialize
#    @uri_inmart = URI('http://inmart.ua/android_weather.php')
#   #humidity~barPressure~airTemp~windSpeed~windDirection
#  end
#  def get_weather
#    parse
#  end
#  
#  private
#  def parse
#    res = Net::HTTP.get_response(@uri_inmart)
#   case res
#    when Net::HTTPSuccess
#      res.body.split("~") # new method
#    else
#      nil
#    end
#  end
# 
#end
