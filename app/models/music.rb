# encoding: utf-8
class Music < ActiveRecord::Base
  belongs_to :artist
  has_many :programs
end
