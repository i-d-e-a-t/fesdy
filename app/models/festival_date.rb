class FestivalDate < ActiveRecord::Base
  belongs_to :festival
  has_many :appearances
  has_many :artists, through: :appearances

  # 画面に表示しても違和感のない、このフェスを表す文字列を返却。
  def to_title
    festival.to_title
  end

  # 画面上でフェス開催をあらわす文字列を返却する。
  def to_detail_for_title
    [
      date.strftime("%Y/%m/%d"),
      place
    ].join "  "
  end

end
