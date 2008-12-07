class House < ActiveRecord::Base
  require 'google_geocode'

  validates_presence_of :address

  def geocode
    gg = load_geocode_key
    loc = gg.locate(self.address)
    self.latitude   = loc.latitude
    self.longitude  = loc.longitude
  end

  private

  def load_geocode_key
    gconf = "#{RAILS_ROOT}/config/gmaps_api_key.yml"
    GoogleGeocode.new(YAML.load_file(gconf)[RAILS_ENV])
  end

end
