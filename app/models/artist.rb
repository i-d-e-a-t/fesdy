# encoding: utf-8
class Artist < ActiveRecord::Base
  has_many :appearances
  has_many :festivals, through: :appearances

  # 同じpath_keyは登録不可
  validates :path_key,
    presence: true,
    uniqueness: true
end
