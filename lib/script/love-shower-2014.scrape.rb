require './scrape_helper.rb'

LOVE_SHOWER_OUTNAME = './love-shower-2014.artists'

# 既に存在するファイルを退避
stash_old_file(LOVE_SHOWER_OUTNAME)

url = 'http://www.sweetloveshower.com/artist/index.html'

# 日毎にdateとcssのruleを設定
# urlが日毎に異なる場合はhashの中で指定する
first_day = {
  date: '20140829',
  rule: '#sec01 ul.profList.btn li img[alt]'
}
second_day = {
  date: '20140830',
  rule: '#sec02 ul.profList.btn li img[alt]'
}
third_day = {
  date: '20140831',
  rule: '#sec03 ul.profList.btn li img[alt]'
}
love_shower_days = [first_day, second_day, third_day]

# 日毎にスクレイプしてファイル出力
love_shower_days.each do |d|
  result = scrape_with_nokogiri(url, d[:rule])

  artists = []
  result.each do |r|
    artists << r['alt'].to_s
  end

  print_to_file(LOVE_SHOWER_OUTNAME, artists, d[:date])
end

# 退避したファイルを削除
delete_old_file(LOVE_SHOWER_OUTNAME)
