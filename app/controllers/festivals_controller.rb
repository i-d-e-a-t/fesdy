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

  def study
    # フェスを探す
    fest = Festival.where(path_key: params[:festival_id]).last ||
           Festival.where(path_key: params[:id]).last
    unless fest
      # nilならnot found
      render status: :not_found and return
    end

    # 次はdateを探す
    date = fest.festival_dates.where(path_key: params[:date_id]).last

    if date
      @artist = date.artists.sample
    else
      @artist = fest.artists.sample
    end

    @yt_video_ids = get_yt_video_ids(@artist.name)
  end


  def next_song
    # 今再生しているアーティスト再生済みにうつす
    @played_artist_ary << @artist_ary.first
    @artist_ary = @artist_ary.drop(1)

    # 全アーティスト一周したらシャッフルしてやりなおし
    @artist_ary = @played_artist_ary.shuffle! if @artist_ary.empty?

    @artist = @artist_ary.first
    @yt_video_ids = get_yt_video_ids(@artist.name)
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
