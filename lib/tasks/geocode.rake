require 'rubygems'
require 'google_geocode'

desc "Given an address, retrieve the geocode information from Google"
task :geocode do

  puts "Geocoding #{ARGV[1...ARGV.length].collect{|a| a + " "}.to_s}"
  gg = GoogleGeocode.new YAML.load_file("#{RAILS_ROOT}/config/gmaps_api_key.yml")[RAILS_ENV]
  loc = gg.locate ARGV[1...ARGV.length].collect{|a| a + " "}.to_s
  puts "#{loc.latitude}     #{loc.longitude}"
end

