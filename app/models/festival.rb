# encoding: utf-8
class Festival < ActiveRecord::Base
  has_many :appearances
  has_many :artists, through: :appearances
end
