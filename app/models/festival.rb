# encoding: utf-8
class Festival < ActiveRecord::Base
  has_many :appearances
  has_many :artists, through: :appearances

  # 同じpath_keyは登録不可
  validates :path_key,
    presence: true,
    uniqueness: true
end
