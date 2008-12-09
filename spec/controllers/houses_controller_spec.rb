require File.dirname(__FILE__) + '/../spec_helper'

describe HousesController do

  # it_should_behave_like 'a RESTful controller with an index action'
  describe 'handling index (GET /plural)' do
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
      House.stubs(:find).with(:all).returns(houses)
      get :index
      assigns[:houses].should  == houses
    end

    it 'should assign a google map' do
      get :index
      assigns[:map].should_not be_nil
    end
  end

  describe 'handling create (POST /singular)' do
    describe 'when successful' do
      it 'should geocode the house'
      it 'should save the house'
      it 'should flash a success notice'
      it 'should redirect to index'
    end
    describe 'when unsuccessful' do
      it 'should flash an error notice'
      it 'should rerender the new house form'
    end
  end

  describe 'handling update (POST /singular)' do
    it 'should find the house being updated'
    describe 'when successful' do
      it 'should redirect to index'
    end
    describe 'when unsuccessful' do
      it 'should rerender the house form'
    end
  end

  describe 'handling mls (POST /singular)' do
    it 'should find the house being updated'
    it 'should receive an mls number'
    it 'should find the house from a 3rd party mls listing'
    describe 'when successful' do
      it 'should redirect to index'
    end
    describe 'when unsuccessful' do
      it 'should rerender the house form'
    end
  end
end
