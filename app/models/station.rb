class Station < ActiveRecord::Base
  belongs_to :brand
  has_many :prices
end