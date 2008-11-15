require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe House do
  describe 'object' do
    before :each do
      @house = House.new
    end

    it 'can have an MLS listing' do
      @house.should respond_to(:mls)
    end

    it 'can have a link to the listing website' do
      @house.should respond_to(:link)
    end

    it 'can have an address' do
      @house.should respond_to(:address)
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
end

