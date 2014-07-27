# encoding: utf-8
class FestivalDate < ActiveRecord::Base
  belongs_to :festival
  has_many :appearances
  has_many :artists, through: :appearance
end
