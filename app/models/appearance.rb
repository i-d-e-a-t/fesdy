# encoding: utf-8
class Appearance < ActiveRecord::Base
  belongs_to :festival
  belongs_to :artist
  has_many :programs
  has_many :musics, through: :programs
end
