class Cocktail < ApplicationRecord
  has_many :doses, dependent: :destroy
  has_many :ingredients, through: :doses
  validates_uniqueness_of :name
  validates_presence_of :name
end
