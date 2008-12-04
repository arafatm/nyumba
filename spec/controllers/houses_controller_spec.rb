require File.dirname(__FILE__) + '/../spec_helper'

describe HousesController do

  # it_should_behave_like 'a RESTful controller with an index action'
  describe 'handling GET /plural (index)' do

    it 'should be successful' do
      get :index
      response.should be_success
    end

    it 'should render template index' do
      get :index
      response.should render_template('index')
    end

    it 'should assign houses for the view' do
      houses = [House.generate!, House.generate!, House.generate!]
      houses.stubs(:find).with(:all).returns(houses)
      get :index
      assigns[:houses].should  == houses
    end

    it 'should assign a google map' do
      #TODO: Why does map.expects(:new) not work?
      get :index
      assigns[:map].should_not be_nil
    end
  end

  describe 'handling POST /singular (create)' do
    describe 'when successful' do
      it 'should save the house'
      it 'should flash a success notice'
      it 'should redirect to index'
    end
    describe 'when unsuccessful' do
      it 'should flash an error notice'
      it 'should rerender the new record form'
    end
  end
end
