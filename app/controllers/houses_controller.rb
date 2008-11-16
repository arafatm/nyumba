class HousesController < ApplicationController
  require 'rubygems'
  require 'google_geocode'

  resources_controller_for :houses

end
