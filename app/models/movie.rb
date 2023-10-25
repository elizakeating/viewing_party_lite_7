class Movie < ApplicationRecord
  validates_presence_of :title, :rating, :description
  has_many :viewing_parties
end 