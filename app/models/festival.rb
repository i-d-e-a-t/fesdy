class Festival < ActiveRecord::Base
  has_many :festival_dates
  has_many :appearances, through: :festival_dates
  has_many :artists, through: :appearances

  # 画面に表示しても違和感のない、このフェスを表す文字列を返却。
  def to_title
    name
  end

  # 同じpath_keyは登録不可
  validates :path_key,
    presence: true,
    uniqueness: true
end
