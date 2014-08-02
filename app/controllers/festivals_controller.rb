# encoding: utf-8
class FestivalsController < ApplicationController
  before_filter :prepare_festival,
    only: :show

  def show
    # festivalが見つからない場合はnot foundを返却
    render status: :not_found and return if @festival.nil?

    # 開催情報を取得。日付の若い順に並べる。
    @dates = @festival.festival_dates.sort do |a, b|
      a.date <=> b.date
    end

    # 開始日、終了日を取得
    @start_date = @dates.first
    @end_date = @dates.last

    # 開催場所を取得
    # @datesには場所が重複して入っている場合があるので注意。
    @places = []
    @dates.each do |date|
      @places << date.place unless @places.include? date.place
    end
  end

  private
  #
  # パスパラメーターidからfestivalを検索する
  #
  def prepare_festival
    fs = Festival.where(path_key: params[:id])
    # 検索結果0件の場合はnilになる。
    @festival = fs.last
  end
end
