require File.dirname(__FILE__) + '/../spec_helper'

describe HousesController do

  describe 'handling GET /plural (index)' do
    it 'should assign houses' do
      houses = [stub(:House), stub(:House), stub(:House)]
      houses.stubs(:find).with(:all).returns(houses)
      get :index
    end

    it 'should render template index' do
      get :index
      response.should render_template('index')
    end

    it 'should load a google map' do
      map = stub(:map)
      #TODO: Why does map.expects(:new) not work?
      map.stubs(:new)
      get :index
    end

    it 'should create a large google map' do
      map = stub(:map)
      map.stubs(:control_init).with(:large_map => true, :map_type => true)
      get :index
    end

    it 'should center the map on nashville' do
      map = stub(:map)
      map.stubs(:center_zoom_init).with([36.058887, -86.782056],10)
      get :index
    end

    it 'should mark all houses on the map' do
      map = stub(:map)
      map.stubs(:overlay_init)
      get :index
    end
  end

  it_should_behave_like 'a RESTful controller with a show action'
end
