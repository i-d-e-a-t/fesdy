# encoding: utf-8
class Program < ActiveRecord::Base
  belongs_to :music
  belongs_to :appearance
end
