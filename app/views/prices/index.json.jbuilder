json.array!(@prices) do |price|
  json.extract! price, :id, :fuel_type, :price, :station_id
  json.url price_url(price, format: :json)
end
