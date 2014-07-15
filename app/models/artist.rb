# encoding: utf-8
class Artist < ActiveRecord::Base
  has_many :festivals, through: :appearances
  has_many :musics
end
