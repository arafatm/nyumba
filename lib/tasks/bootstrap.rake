task :bootstrap => :environment do

  # Create User
  House.generate
  House.generate
  House.generate
  House.generate
  House.generate
end
