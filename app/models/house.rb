class House < ActiveRecord::Base
  require 'google_geocode'

  validates_presence_of :address

  def geocode_address
    self.geocode = lookup_address(address)
  end

  def lookup_address(address)
    GoogleGeocode.new(geocode_config)
  end


  def old_geocode
    
    gg = load_geocode_key
    loc = gg.locate(self.address)
    self.geocode   = "#{loc.latitude} #{loc.longitude}"
  end

  private

  def load_geocode_key
    gconf = "#{RAILS_ROOT}/config/gmaps_api_key.yml"
    GoogleGeocode.new(YAML.load_file(gconf)[RAILS_ENV])
  end

end
