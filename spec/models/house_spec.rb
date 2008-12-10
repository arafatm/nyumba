require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe House do
  before :each do
    @house = House.new
  end

  describe '' do
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

  describe 'geocoder' do
    it 'should look up the address' do
      @address = 'foo'
      h = House.new(:address => @address)
      h.expects(:lookup_address).with(@address)
      h.geocode_address
    end

    it 'should save the geocoded address' do
      h = House.new
      h.stubs(:lookup_address).returns('the geocode')
      h.geocode_address
      h.geocode.should == 'the geocode'
    end

    describe 'when looking up an address' do
      before :each do
        @address = 'the address'
        @config = 'config'
        @house = House.new
        @house.stubs(:geocode_config).returns(@config)
      end

      it 'should create a Google geocoder' do
        GoogleGeocode.expects(:new)
        @house.geocode_address
      end

      it 'should use the geocode config file when creating the Google geocoder' do
        @house.stubs(:geocode_config).returns(@config)
        GoogleGeocode.expects(:new).with(@config)
        @house.geocode_address
      end

      it 'should lookup the address via the geocoder'
      it 'should return the geocoded result'
    end


    it 'can geocode an address' do
      pending('foo')
      gg = mock(GoogleGeocode)
      GoogleGeocode.stubs(:new).returns(gg)
      loc = mock(GoogleGeocode::Location)
      GoogleGeocode.stubs(:locate).with("some address").returns(loc)
      GoogleGeocode::Location.stubs(:latitude).returns('some_latitude')
      GoogleGeocode::Location.stubs(:longitude).returns('some_longitude')
      house = House.new
      house.address = 'some address'
      house.geocode
    end
  end
end
