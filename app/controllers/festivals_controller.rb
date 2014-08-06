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

  #
  # Studyページ
  #
  def study
    @artist_ary = []

    #URIで指定されたfes名と合致するfesをまず探す
    Festival.where(path_key: params[:festival_id]).each do |fest|
      #日付なしで飛んできたものはアーティストを詰め込む
      if params[:date_id].nil?
        @artist_ary += fest.artists.all.shuffle
      # 日付ありで飛んできた場合はさらに日付と合致するアーティストを詰め込む
      elsif
        fest.festival_dates.where(path_key: params[:date_id]).each do |dt|
          @artist_ary += dt.artists.all.shuffle
        end
      end

    end

    if @artist_ary
      play_yt_seequence
    else
      render status: :not_found and return
    end
  end

  def play_yt_seequence
    @yt_video_ids = get_yt_video_ids(@artist_ary.first.name)
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
