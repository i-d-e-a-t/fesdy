# encoding: utf-8
class ArtistController < ApplicationController

  require 'rubygems'
  require 'google/api_client'
  require 'trollop'

  #
  # Artistページ
  #
  def show
    # TODO: path_key使う
    @artist = Artist.where(:id => params[:id]).last
    @yt_video_ids = get_yt_video_ids(@artist.name)
  end


  private

  #
  # Artist名をキーにYoutube検索を行い、Video-Idを最大3件配列で返却
  #

  DEVELOPER_KEY = "AIzaSyB8r2JlGrH-zL7Eh0S3O11134jzTv4HAeM"
  YOUTUBE_API_SERVICE_NAME = "youtube"
  YOUTUBE_API_VERSION = "v3"
  NUM_OF_LIST = 3

  def get_yt_video_ids(artist_name)
    # clientの設定
    client = Google::APIClient.new(:key => DEVELOPER_KEY,
                                   :authorization => nil)
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    
    # Optionの設定(検索キーワード/取得数)
    opts = Trollop::options do
      opt :q, 'Search term', :type => String, :default => artist_name
      opt :maxResults, 'Max results', :type => :int, :default => NUM_OF_LIST
    end

    # 検索実行
    opts[:part] = 'id,snippet'
    search_response = client.execute!(
      :api_method => youtube.search.list,
      :parameters => opts
    )

    # 検索結果からIDだけ取得
    yt_video_ids = []
    search_response.data.items.each do | search_result |
      if search_result.id.kind == 'youtube#video'
        yt_video_ids << search_result.id.videoId
      end
    end

    return yt_video_ids;
  end


end
