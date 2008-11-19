ActionController::Routing::Routes.draw do |map|
  map.resources :houses, :new => { :mls => :post }

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
