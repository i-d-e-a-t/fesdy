# encoding: utf-8
class Festival < ActiveRecord::Base
  has_many :festival_dates
  has_many :appearances, through: :festival_dates
  has_many :artists, through: :appearances

  # 同じpath_keyは登録不可
  validates :path_key,
    presence: true,
    uniqueness: true
end
