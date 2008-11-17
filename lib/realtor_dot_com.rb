require 'rubygems'
require 'nokogiri'
require 'mechanize'

class RealtorDotCom
  def parse(mlsid = '1014572')
    WWW::Mechanize.html_parser = Nokogiri::HTML

    listing = Hash.new

    agent = WWW::Mechanize.new

    page = agent.get("http://www.realtor.com/search/searchresults.aspx?mlslid=#{mlsid}")

    addresses = page.search("div.lvAddress a")

    details = "http://www.realtor.com#{addresses[0].attributes['href']}"
    page = agent.get(details)


    # Set up address
    address =  page.search("h1.hsLDPrw1")
    address = address[0].inner_html
    address.gsub! /<b>/, ''
    address.gsub! /<\/b><br\/>/, ', '
    address.gsub! /<br\/><br\/>/, ''
    listing[:address] = address


    # Set up price
    price   =  page.search("div.hsLDPrw2")
    listing[:price] = price[0].inner_html[/\$(\d*,)*\d*/].gsub!(/[^\d]/, '')

    # Set up beds, baths, size in acreage
    info   =  page.search("div.hsLDPrw3")[0].inner_html
    listing[:bed]  = info[/\d+ Bed/][0..-5]
    listing[:bath] = info[/\d+(.\d+)? Bath/][0..-6]
    listing[:size] = info[/\d+(,\d+)? Sq Ft/][0..-7].gsub!(/[^\d]/, '')
    listing[:acre] = info[/\d+(.\d+)? Acres/][0..-7]

    listing
  end
end
