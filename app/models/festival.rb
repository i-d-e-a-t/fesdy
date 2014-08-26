class Festival < ActiveRecord::Base
  has_many :festival_dates
  has_many :appearances, through: :festival_dates
  has_many :artists, through: :appearances

  # 画面に表示しても違和感のない、このフェスを表す文字列を返却。
  def to_title
    name
  end

  # 新しい順に並べたフェスを返す。
  # フェスの開始日を元に並べる。
  def self.sort
    old_first_list = Festival.all.sort_by do |fes|
      fes.festival_dates.order(:date).pluck(:date).first.to_i
    end

    return old_first_list.reverse
  end

  # フェス開催の場合は詳細を出す。
  # 互換性のためnilを返却
  def to_detail_for_title; end

  # 同じpath_keyは登録不可
  validates :path_key,
    presence: true,
    uniqueness: true
end
