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
  # 予習画面
  #     fes指定のみの場合:　フェス予習
  #     fes & date指定の場合:  フェス開催別予習
  #
  def study
    # フェスを探す
    # prepare_...を使わないのは、
    # idにdateのpath_keyが設定されている可能性があるため。
    @fest = Festival.where(path_key: params[:festival_id]).last ||
            Festival.where(path_key: params[:id]).last
    unless @fest
      # nilならnot found
      render status: :not_found and return
    end

    # 次はdateを探す
    @date = @fest.festival_dates.where(path_key: params[:date_id]).last

    if params[:festival_id] && params[:date_id] && @date.nil?
      # フェス開催ごとの予習をさすURLなのに、@dateがnilの場合、not found
      render status: :not_found and return
    end

    # 予習ターゲットを判別
    target = @date ? @date : @fest

    # アーティストを取得(すでに予習中のときはsessionから取得)
    @artist = lets_study target

    # TODO 1件にする
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

  #
  # 予習用ハッシュがnilの場合、予習スタート。
  # アーティストのオブジェクトを返却する
  # フェス開催日別と、フェス全体の二種類の挙動がある。
  #
  def lets_study it
    key = :study_list
    study_id_key = :study_id
    expected_study_id = it.path_key
    autoplay_key = :study_autoplay
    # 1. 違うstudy_idで予習中
    # 2. 予習してない
    # 3. 予習が終わったところ
    # 4. 不正な値
    #
    # 以上のいずれかに当てはまる場合、新しく予習開始
    new_study = (
      session[study_id_key] != expected_study_id ||
      session[key].nil? ||
      session[key].empty? ||
      session[key].class != Array
    )

    if new_study
      # 予習の識別子を保持
      session[study_id_key] = expected_study_id
      # 自動再生はしない
      session[autoplay_key] = 'no'
      # 予習開始なので、まずはDB検索。
      # TODO 10件
      # シャッフルして取得。
      targets = it.artists.pluck(:id).shuffle!.pop 10
      # セッションに格納
      session[key] = targets
    else
      # 予習開始後の次の画面なので、autoplayを有効化
      session[autoplay_key] = 'yes'
    end
    # 最初にシャッフルしているので、そのままpop
    aid = session[key].shuffle!.pop
    # アーティストを返却
    return Artist.find(aid)
  end

end
