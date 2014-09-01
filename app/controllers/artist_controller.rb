# encoding: utf-8
class ArtistController < ApplicationController

  #
  # Artistページ
  #
  def show
    @artist = Artist.where(:path_key => params[:id]).last
    if @artist != nil
      @yt_video_ids = get_yt_video_ids(@artist.name)
    else
      render status: :not_found and return
    end
  end

  #
  # itunesを検索し、パーシャルなHTMLで返却する。
  #
  def search_itunes
    render :text => params[:keyword]
  end
end
