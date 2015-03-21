class WeatherController < ApplicationController
  def initialize
  super 
    @temp = "+7.7"
	@bar = "780"
	@humidity = "86.0"
	@wind_s = "5.6"
	@wind_d = "North"
	@sunrise = "06:00"
	@sunset = "17:00"
	@moon = "Full"
	
	@date = Time.now
	
  end
  def get
    @day = @date.day < 10 ? "0" + @date.day.to_s : @date.day.to_s
	@month = @date.month < 10 ? "0" + @date.month.to_s : @date.month.to_s
	@year = @date.year
	@moon = StaticData.get_moon[0]
	
	param_sun = StaticData.get_sun(1,2,3,4)
	@sunrise = param_sun[0]
	@sunset = param_sun[1]
  end
  
end
