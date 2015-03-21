class StaticData
  def self.get_moon
    prepare_moon_data
  end
  def self.get_sun(la, lo, loc_offset, zenith)
    prepare_sun_data(la, lo, loc_offset, zenith)
  end
  
  private
  def self.prepare_moon_data
    ["Full moon"]
  end
  def self.prepare_sun_data(la, lo, loc_offset, zenith)
    ["6:40", "17:01"]
  end
end
