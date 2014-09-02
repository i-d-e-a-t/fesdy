require 'httpclient'

module ItunesAdapter
  # 検索APIのベースURL
  ITUNES_API = {
    search: "http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch"
  }

  # キーワードで検索した結果をHashWithIndifferentAccessオブジェクトで返す。
  #     option == :raw の場合
  #         結果のJSONをそのまま返却する
  def self.search keyword, option=nil
    raw = self.request_search keyword
    if option == :raw
      return raw
    else
      return JSON.parse(raw).with_indifferent_access
    end
  end

  # キーワードを引数に検索
  # 結果（JSON）をテキストで返却する
  def self.request_search keyword
    http_client = HTTPClient.new
    http_client.get_content(ITUNES_API[:search], {term: keyword})
  end

end
