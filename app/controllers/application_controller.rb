# encoding: utf-8
class ApplicationController < ActionController::Base
  extend SecretKeeper

  require 'google/api_client'
  require 'trollop'

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :prepare_for_header

  private
  def prepare_for_header
    @festivals = Festival.all
  end

  # search_wordをキーにYoutube検索を行い、Video-Idを最大3件配列で返却
  DEVELOPER_KEY = secret :youtube_apikey
  YOUTUBE_API_SERVICE_NAME = "youtube"
  YOUTUBE_API_VERSION = "v3"
  NUM_OF_LIST = 3
  APPLICATION_NAME = "Fesdy"
  APPLICATION_VERSION = "0.01"

  def get_yt_video_ids(search_word)
    # clientの設定
    client = Google::APIClient.new(:key => DEVELOPER_KEY,
                                   :authorization => nil,
                                   :application_name => APPLICATION_NAME,
                                   :application_version => APPLICATION_VERSION)
    youtube = client.discovered_api(YOUTUBE_API_SERVICE_NAME, YOUTUBE_API_VERSION)
    
    # Optionの設定(検索キーワード/取得数)
    opts = Trollop::options do
      opt :q, 'Search term', :type => String, :default => search_word
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

    return yt_video_ids
  end

end
