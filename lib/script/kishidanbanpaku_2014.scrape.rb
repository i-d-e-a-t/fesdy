# 氣志團万博2014の出演者を取得するスクリプト
# kishidanbanpaku-2014.artists というファイルに
# 1行1アーティストの形式で出力する。

require_relative './scrape_helper.rb'

OUTPUT_FILE = './kishidanbanpaku-2014.artists'

# 既に存在するファイルを退避
stash_old_file(OUTPUT_FILE)

url = 'http://www.kishidanbanpaku.com/artist/index.html'

# 日毎にdateとcssのruleを設定
# urlが日毎に異なる場合はhashの中で指定する

def get_rule(i)
  "#day#{i} .box a img"
end

dates = [
  {
    date: '20140913',
    rule: get_rule(1)
  },
  {
    date: '20140914',
    rule: get_rule(2)
  },
  {
    date: '20140915',
    rule: get_rule(3)
  }
]

# 日毎にスクレイプしてファイル出力
dates.each do |d|
  result = scrape_with_nokogiri(url, d[:rule])

  artists = []
  result.each do |r|
    artists << r['alt'].to_s
  end

  print_to_file(OUTPUT_FILE, artists, d[:date])
end

# 退避したファイルを削除
delete_old_file(OUTPUT_FILE)
