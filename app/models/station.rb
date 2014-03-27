class Station < ActiveRecord::Base
  belongs_to :brand
  has_many :prices


  acts_as_mappable :default_units => :kms,
                   :default_formula => :sphere,
                   :distance_field_name => :distance,
                   :lat_column_name => :latitude,
                   :lng_column_name => :longitude

  def self.zoom_level
    17
  end
end