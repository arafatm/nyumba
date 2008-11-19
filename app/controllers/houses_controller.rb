class HousesController < ApplicationController
  require 'rubygems'
  require 'google_geocode'

  resources_controller_for :houses

  def index
    self.resources = find_resources

    gg = load_geocode_key
    @map = GMap.new("map_div")
    @map.control_init(:large_map => true,:map_type => true)
    @map.center_zoom_init([36.058887, -86.782056],10)

    self.resources.each do |house|
      loc = house.geocode.split(' ')
      info =  "#{house.address}<BR>"
      info << "(#{house.year}) "
      info << "$#{house.price} ($#{house.taxes})<BR>"
      info << "#{house.bedrooms} BR / "
      info << "#{house.bathrooms} BA "
      info << "#{house.acres} Acres"
      @map.overlay_init(GMarker.new([loc[0], loc[1]],
                                    :title => house.mls, 
                                    :info_window => info))
    end
  end

  def create
    self.resource = new_resource

    if resource.address != nil
      resource.geocode = geocode(resource.address)
    end
    if resource.save
      flash[:notice] = "Added new property"
      redirect_to houses_path
    else
      flash[:error] = "Failed to save this property"
      render :action => "new"
    end
  end

  def mls
    debugger
    house = House.new
    house.mls = params[:house][:mls]
    parser = RealtorDotCom.new
    listing = parser.parse(house.mls) 
    house.update_attributes listing
    house.geocode = geocode(house.address)

    if house.save
      flash[:notice] = "Added new listing with MLS #{house.mls}"
    else
      flash[:error] = "Unable to save this listing. Please verify and try again"
    end
    redirect_to houses_path

  end

  def update
    self.resource = find_resource
    resource.attributes = params[resource_name]

    if resource.save
      redirect_to houses_path
    else
      render :action => "edit"
    end
  end

  private

  def load_geocode_key
    GoogleGeocode.new YAML.load_file("#{RAILS_ROOT}/config/gmaps_api_key.yml")[RAILS_ENV]
  end

  def geocode(address)
    gg = load_geocode_key
    loc = gg.locate(address)
    "#{loc.latitude} #{loc.longitude}"
  end


end
