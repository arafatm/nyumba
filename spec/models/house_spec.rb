require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe House do
  before :each do
    @house = House.new
  end

  describe 'attributes' do
    it 'can have an MLS listing' do
      @house.should respond_to(:mls)
    end

    it 'can have a link to the listing website' do
      @house.should respond_to(:link)
    end

    it 'can have an address' do
      @house.should respond_to(:address)
    end

    it 'must have an address' do
      @house.address = nil
      @house.should_not be_valid
      @house.should have(1).errors_on(:address)
    end

    it 'can have geocoded lat/long' do
      @house.should respond_to(:geocode)
    end
    it 'can have bedrooms' do
      @house.should respond_to(:bedrooms)
    end
    it 'can have bathrooms' do
      @house.should respond_to(:bathrooms)
    end
    it 'can have acres of yard space' do
      @house.should respond_to(:acres)
    end
    it 'can have a listing price' do
      @house.should respond_to(:price)
    end
    it 'can have property taxes' do
      @house.should respond_to(:taxes)
    end
    it 'can have a year in which it was built' do
      @house.should respond_to(:year)
    end
  end
  describe 'validates' do
    it 'address is required' do
      house = House.generate(:address => nil)
      house.errors.on(:address).should eql("can't be blank")
    end
  end
  describe 'before filters' do
    it 'should geocode the address before saving' do
      @house = House.generate!(:geocode => nil)
      @house.expects(:geocode_address)
      @house.save
    end
  end

  describe 'geocoding' do
    before :each do
      @house = House.generate!(:address => '1 Titans Way, Nashville, TN')

      @geocoder = GoogleGeocode.new(
        YAML.load_file("#{RAILS_ROOT}/config/gmaps_api_key.yml")[RAILS_ENV])

        @location = GoogleGeocode::Location.new
        @location.address = "1 Titans Way, Nashville, TN 37213, USA"
        @location.latitude = "36"
        @location.longitude = "83"
    end

    it 'should try to geocode on save' do
      @house.expects(:geocode_address)
      @house.save
    end

    it 'should not geocode if address is empty' do
      pending "How do I test should not save?"
    end

    it 'should not geocode if it already has geocode' do
      pending "How do I test should not save?"
    end

    it 'should set a location' do
      @house.expects(:geocode_with_google).with(@house.address).returns(@location)
      @house.geocode_address
    end

    it 'should set address geocode with a latitude and longitude' do
      @house.geocode_address
      @house.geocode.should == "36.166218 -86.771413"
    end

    describe 'with Google geocoder' do
      it 'should create an instance of GoogleGeocode' do
        GoogleGeocode.expects(:new).returns(@geocoder)
        @house.geocode_address
      end

      it 'should load the config file with the API key' do
        GoogleGeocode.expects(:new).with('ABQIAAAAEHrGEEDcDATMc8Z9y01qlBRu2GvCUMWgdpKNrF0dfFQEA9cx2hTHZYC7aMrxibrIYx4retPD_oIReA').returns(@geocoder)
        @house.geocode_address
      end

      it 'should return a valid geocode for a valid address' do
        GoogleGeocode.any_instance.expects(:locate).returns(@location)
        @house.geocode_address
      end

      it 'should return an \'unkown error 400\' code for an empty address' do
        pending "Not sure if I should test this. Address is required"
        house = House.generate!(:address => '')
        lambda {house.geocode_address}.should_raise_error GoogleGeocode::Error
      end

      it 'should return an \'unkown address\' code for an empty address' do
        pending
        house = House.generate!(:address => 'XXX')
        lambda {house.geocode_address}.should_raise_error(
          GoogleGeocode::AddressError)
      end
    end
  end
end
