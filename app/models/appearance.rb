# encoding: utf-8
class Appearance < ActiveRecord::Base
  belongs_to :festival_date
  belongs_to :artist
end
