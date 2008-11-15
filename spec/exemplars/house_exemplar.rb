class House 

  generator_for(:mls)      { rand(999999) }
  generator_for(:link)     { "http://#{rand(999999)}.nyumba.com" }
  generator_for(:address,  :method => :address_generator)  
  generator_for(:geocode,  :method => :geocode_generator)
  generator_for(:bedrooms) { rand(9) + 1 }
  generator_for(:bathrooms){ rand(5) + 1 }
  generator_for(:acres)    { rand(5) + (rand(999)*0.001) }
  generator_for(:price)    { rand(999999) + 100000 }
  generator_for(:taxes)    { rand(5000) + 500 }
  generator_for(:year)     { rand(100) + 1908 }


  def self.address_generator
    num = rand(899) + 100
    directions = ['N', 'E', 'S', 'W']
    direction = directions[rand(4)]
    street = rand(98) + 1
    "#{num} #{direction} #{street} Street, Nashville, TN"
  end

  def self.geocode_generator
    # Keeping it close to Nashville for testing
    sprintf("%0.6f -%0.6f", (rand/2) + 35.8, rand*4/5 + 86.2)
  end

  def self.link_next
  end
  def self.next
    rand(999999)
  end
end

