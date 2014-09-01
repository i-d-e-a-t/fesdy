require 'httpclient'

module ItunesAdapter
  # 検索APIのベースURL
  ITUNES_API = {
    search: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch"
  }

  def self.search keyword, options={}
    # キーワードを引数に検索
    http_client = HTTPClient.new
    http_client.get_content(ITUNES_API[:search], {term: keyword})
  end
end
