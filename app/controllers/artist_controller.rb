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
    # 0件だったら空文字列を返す
    render :text => '' and return if raw_result[:resultCount] == 0
    @itunes_results = raw_result[:results]
    render :layout => nil
  end

  #
  # params[:id]からアーティストを取得する
  #
  private
  def prepare_artist
    @artist = Artist.where(:path_key => params[:id]).last
    if @artist.nil?
      render text: 'Not Found', status: :not_found and return
    end
  end

end
