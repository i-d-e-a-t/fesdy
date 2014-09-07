# encoding: utf-8
class Artist < ActiveRecord::Base
  has_many :appearances
  has_many :festival_dates, through: :appearances
  has_many :festivals, through: :festival_dates
end
