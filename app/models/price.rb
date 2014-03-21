class Price < ActiveRecord::Base
  belongs_to :station
  
  def self.download
    require 'httparty'
    stations = HTTParty.get('http://paliwko.shellyapp.com/api/station/nearby?longitude=17.03&latitude=51.1&range=20').parsed_response['data']
    stations.each do |station|
      puts
      puts station
      prices = station['prices']
      next if prices.empty?
      prices.each do |price|
        p price
        next if price['price'] == 0
        record = {:fuel_type => price['fuel_code'], :station_id => station['id'], :price => price['price'], :updated_at => DateTime.strptime(price['updated_at'], '%Y-%m-%dT%H:%M:%S')}
        p record
        Price.new( record  ).save if price['price'] != 0
      end
    end   
  end
end