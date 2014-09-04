require 'httpclient'

# ItunesAPIと接続するインターフェース
module ItunesAdapter
  # 検索APIのベースURL
  ITUNES_API = {
    search: 'https://itunes.apple.com/search'
  }

  def self.search(keyword)
    request_search keyword
  end

  # キーワードを引数に検索
  # 結果（JSON）をテキストで返却する
  def self.request_search(keyword)
    http_client = HTTPClient.new
    http_client.get_content(ITUNES_API[:search], term: keyword, country: 'JP')
  end
end
