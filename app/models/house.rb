class House < ActiveRecord::Base
  require 'google_geocode'

  validates_presence_of :address

  before_save :geocode_address

  def geocode_address
    if (address != nil) && (geocode == nil)
      loc = geocode_with_google(self.address)
      self.geocode = "#{loc.latitude} #{loc.longitude}"
    end
  end

  private

  def geocode_with_google(address)
    google_geocoder = create_google_geocoder
    google_geocoder.locate(address)
  end

  def create_google_geocoder
    GoogleGeocode.new(load_google_config)
  end

  def load_google_config
    YAML.load_file(
      "#{RAILS_ROOT}/config/gmaps_api_key.yml")[RAILS_ENV]
  end
end
