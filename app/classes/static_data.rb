class StaticData
  def self.get_moon(y, m, d)
    prepare_moon_data(y, m, d)
  end
  def self.get_sun(y, m, d, la, lo, loc_offset, zenith)
    prepare_sun_data(y, m, d, la, lo, loc_offset, zenith)
  end
  
  private
  def self.prepare_moon_data(year, month, day)
    moon = 'unknown'
	yy = (year - ((12 - month) / 10.0).floor).to_int
	mm = month + 9
	
	if mm >= 12 then
	  mm = mm - 12
	end
	
	k1 = (365.25 * (yy + 4712.0)).floor.to_int
	k2 = (30.6 * mm + 0.5 ).floor.to_int
	k3 = ((((yy / 100.0) + 49.0).floor * 0.75).floor - 38).to_int
	
	jd = k1 + k2 + day + 59 # for dates in Julian calendar
    if jd > 2299160 then
      jd = jd - k3          # for Gregorian calendar
    end
	
    # calculate moon's age in days
    ip = normalize((jd - 2451550.1) / 29.530588853)
    ag = ip * 29.53
	
	if ag < 1.84566 
	  moon = 'New'
	elsif ag < 5.53699 
	  moon = 'Waxing crescent'
	elsif ag < 9.22831
	  moon = 'First quarter'
	elsif ag < 12.91963 
	  moon = 'Waxing gibbous'
	elsif ag < 16.61096 
	  moon = 'Full'
	elsif ag < 20.30228
	  moon = 'Waning gibbous'
	elsif ag < 23.99361 
	  moon = 'Last quarter'
	elsif ag < 27.68493 
	  moon = 'Waning crescent'
	else 
	  moon = 'New'
	end
	
    moon #+ ' ' + ag.to_s
  end
  
  def self.normalize(v)
  v = v - v.floor
    if v < 0 then
      v = v + 1.0;
    end
  v
  end
  
  def self.to_radians(angle)
    angle / 180 * Math::PI
  end
  
  def self.to_degrees(angle)
    angle * 180 / Math::PI 
  end  
  
  def self.prepare_sun_data(year, month, day, latitude, longitude, loc_offset, zenith)
    sun = {:sunrise => 'unknown', :sunset => 'unknown'}
	
	# 1. first calculate the day of the year
    n1 = (275 * month / 9).floor
    n2 = ((month + 9) / 12).floor
    n3 = (1 + ((year - 4 * (year / 4).floor + 2) / 3).floor)
    n = n1 - (n2 * n3) + day - 30
	
	# 2. convert the longitude to hour value and calculate an approximate time
    lng_hour = longitude / 15.0
    t_sunrise = n + ((6.0 - lng_hour) / 24.0)
    t_sunset = N + ((18.0 - lng_hour) / 24.0)
	
    # 3. calculate the Sun's mean anomaly
    m_sunrise = (0.9856 * t_sunrise) - 3.289
    m_sunset =  (0.9856 * t_sunset)  - 3.289
	
	
    # 4. calculate the Sun's true longitude
    # [Note throughout the arguments of the trig functions
    # (sin, tan) are in degrees. It will likely be necessary to
    # convert to radians. eg sin(170.626 deg) =sin(170.626*pi/180 radians)=0.16287]
    l_sunrise = m_sunrise + (1.916 * Math.sin(to_radians(m_sunrise))) + (0.020 * Math.sin(to_radians(2 * m_sunrise))) + 282.634
    l_sunset  = m_sunset  + (1.916 * Math.sin(to_radians(m_sunset))) +  (0.020 * Math.sin(to_radians(2 * m_sunset)))  + 282.634
    # NOTE: L potentially needs to be adjusted into the range [0,360) by adding/subtracting 360
	
	
    if l_sunrise < 0 
      while (!(0 <= l_sunrise && l_sunrise < 360)) do
        l_sunrise += 360
	  end
    elsif l_sunrise >= 360 
      while (!(0 <= l_sunrise && l_sunrise < 360)) do
         l_sunrise -= 360
	   end
    end
	
    if l_sunset < 0
      while (!(0 <= l_sunset && l_sunset < 360)) do
        l_sunset += 360
	  end
    elsif l_sunset >= 360
      while (!(0 <= l_sunset && l_sunset < 360))
        l_sunset -= 360
	  end
    end
	
	
    # 5a. calculate the Sun's right ascension
    ra_sunrise = to_degrees(Math.atan(0.91764 * Math.tan(to_radians(l_sunrise))))
    ra_sunset  = to_degrees(Math.atan(0.91764 * Math.tan(to_radians(l_sunset))))
    # NOTE: RA potentially needs to be adjusted into the range [0,360) by adding/subtracting 360
	
    # 5b. right ascension value needs to be in the same quadrant as L
    l_quadrant =  ((l_sunrise  / 90.0).floor) * 90.0
    ra_quadrant = ((ra_sunrise / 90.0).floor) * 90.0
    ra_sunrise = ra_sunrise + (l_quadrant - ra_quadrant)
    l_quadrant =  ((l_sunset  / 90.0).floor) * 90.0
    ra_quadrant = ((ra_sunset / 90.0).floor) * 90.0
    ra_sunset =  ra_sunset  + (l_quadrant - ra_quadrant)
	
    # 5c. right ascension value needs to be converted into hours
    ra_sunrise = ra_sunrise / 15.0
    ra_sunset =  ra_sunset  / 15.0
	
    # 6. calculate the Sun's declination
    sin_dec_sunrise = 0.39782 * Math.sin(Math.toRadians(l_sunrise))
    cos_dec_sunrise = Math.cos(Math.asin(sin_dec_sunrise))
    sin_dec_sunset = 0.39782 * Math.sin(Math.toRadians(l_sunset))
    cos_dec_sunset = Math.cos(Math.asin(sin_dec_sunset))
	
	
	#############################################################################
	#############################################################################
	#############################################################################
	#############################################################################
	#############################################################################
	
	
    # 7a. calculate the Sun's local hour angle
    cosHSunRise = (Math.cos(to_radians(zenith)) - (sinDecSunRise * Math.sin(to_radians(latitude)))) / (cosDecSunRise * Math.cos(to_radians(latitude)))
    cosHSunSet =  (Math.cos(to_radians(zenith)) - (sinDecSunSet  * Math.sin(to_radians(latitude)))) / (cosDecSunSet  * Math.cos(to_radians(latitude)))

    # 7b. finish calculating H and convert into hours
    # if rising time is desired:
    HSunRise = 360.0 - to_degrees(Math.acos(cosHSunRise))
    # if setting time is desired:
    HSunSet = to_degrees(Math.acos(cosHSunSet))
	
    HSunRise = HSunRise / 15.0;
    HSunSet = HSunSet / 15.0;
	
	# 8. calculate local mean time of rising/setting
    TSunRise = HSunRise + raSunRise - (0.06571 * tSunRise) - 6.622
    TSunSet = HSunSet + raSunSet - (0.06571 * tSunSet) - 6.622
	
    # 9. adjust back to UTC
    UTSunRise = TSunRise - lngHour
    UTSunSet = TSunSet - lngHour
    # NOTE: UT potentially needs to be adjusted into the range [0,24) by adding/subtracting 24
    if UTSunRise < 0 
      while (!(0 <= UTSunRise && UTSunRise < 24))
        UTSunRise += 24
	  end
    elsif UTSunRise >= 24
      while (!(0 <= UTSunRise && UTSunRise < 24))
        UTSunRise -= 24
	  end
    end
	
    if UTSunSet < 0
      while (!(0 <= UTSunSet && UTSunSet < 24))
        UTSunSet += 24
	  end
    elsif UTSunSet >= 24
      while (!(0 <= UTSunSet && UTSunSet < 24))
        UTSunSet -= 24
	  end
    end
	
	
    # 10. convert UT value to local time zone of latitude/longitude
    localTSunRise = UTSunRise + loc_offset
    localTSunSet = UTSunSet + loc_offset
	
    if localTSunRise < 0
      while (!(0 <= localTSunRise && localTSunRise < 24))
        localTSunRise += 24
	  end
    elsif localTSunRise >= 24
      while (!(0 <= localTSunRise && localTSunRise < 24))
        localTSunRise -= 24
	  end
    end
	
    if localTSunSet < 0
      while (!(0 <= localTSunSet && localTSunSet < 24))
        localTSunSet += 24
	  end
    else if localTSunSet >= 24
      while (!(0 <= localTSunSet && localTSunSet < 24))
        localTSunSet -= 24
	  end
    end
	
    sun[:sunrise] = value_of_hour(localTSunRise)
    sun[:sunset] = value_of_hour(localTSunSet)

	sun
  end
  
  def self.value_of_hour(h)
    h = hour.to_i
    min = hour - h
    m = (min * 60).to_i
	"%2d:%2d" % [h, m]
  end
end
