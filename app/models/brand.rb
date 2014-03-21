class Brand < ActiveRecord::Base

  has_many :stations
  has_many :prices, :through => :stations

end
