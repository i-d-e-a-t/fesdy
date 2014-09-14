# GAMAROCK2014の出演者を取得するスクリプト
# gamarock-2014.artists というファイルに
# 1行1アーティストの形式で出力する。

require_relative './scrape_helper.rb'

OUTPUT_FILE = './gamarock-2014.artists'
URL = 'http://gamarock.net/2014/music.php'
RULE = '.artist_single h3'

# スクレイプしてファイル出力
html_nodes = scrape_with_nokogiri(URL, RULE)
artists = []
html_nodes.each do |html_node|
  artists << html_node.content
end

print_to_file(OUTPUT_FILE, artists, '20140920')
