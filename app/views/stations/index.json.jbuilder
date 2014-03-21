json.array!(@stations) do |station|
  json.extract! station, :id, :name, :address, :city, :longitude, :latitude, :brand_id
  json.url station_url(station, format: :json)
end
