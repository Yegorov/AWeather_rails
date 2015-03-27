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
    
    @date = Time.now.localtime("+02:00")
  end
  
  def get
    @day = "%02d" % @date.day
    @month = "%02d" % @date.month
    @year = @date.year.to_s
    @moon = StaticData.get_moon(@date.year.to_i, @date.month.to_i, @date.day.to_i)
    
    param_sun = StaticData.get_sun(@date.year.to_i, @date.month.to_i, @date.day.to_i, 48.333611, 38.0925, +2, 90.8333333333)
    @sunrise = param_sun[:sunrise]
    @sunset = param_sun[:sunset]
    
    #test
    #@temp = params[:temp]
    #@moon = params[:moon]

    weather = Parser.parse
    @temp = weather[:temp]
    @bar = weather[:bar]
    @humidity = weather[:humidity]
    @wind_s = weather[:wind_s]
    @wind_d = weather[:wind_d]
  end
  
end
