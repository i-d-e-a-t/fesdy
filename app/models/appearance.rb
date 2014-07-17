# encoding: utf-8
class Appearance < ActiveRecord::Base
  belongs_to :festival
  belongs_to :artist
end
