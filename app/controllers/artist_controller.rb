# /artists/*** に対応するアクションを定義する。
# itunes検索アクションもここ
class ArtistController < ApplicationController
  before_action :prepare_artist

  #
  # Artistページ
  #
  def show
    @yt_video_ids = get_yt_video_ids(@artist.name)
  end

  #
  # itunesを検索し、パーシャルなHTMLで返却する。
  #
  def search_itunes
    raw_result = ItunesAdapter.search @artist.name
    # TODO: なぜかItunesAdapterでHashに変換しても文字列で帰ってくる。要調査
    raw_result = JSON.parse(raw_result).with_indifferent_access
    @itunes_results = raw_result[:results]
    render layout: nil
  end

  private

  #
  # params[:id]からアーティストを取得する
  #
  def prepare_artist
    @artist = Artist.where(path_key: params[:id]).last
    if @artist.nil?
      render text: 'Not Found', status: :not_found
      return
    end
  end
end
