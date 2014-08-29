# spac love showerの出演者を取得するスクリプト
# love-shower-2014.artists というファイルに1行1アーティストの形式で出力する。

require 'nokogiri'
require 'open-uri'
require 'FileUtils'
require 'pry'

# パスキー作成モジュールをインクルード
require_relative '../tasks/ask_path_key.rb'

class String
  def c n; "\e[#{n}m#{self}\e[0m"; end
  def red; c 31; end
  def green; c 32; end
  def yellow; c 33; end
end

###########
#
# アーティスト抽出
#
def scrape_artists apk, url, file = nil

  # 出力用ファイルをオープン
  f = File.open(file, 'w')

  puts "url: #{url}.green"
  begin
    doc = Nokogiri::HTML(open url)
  rescue => e
    puts "#{e.class}".red
    puts e.message.red
    exit 1
  end

  # HTMLからartist名を取得
  result_829 = doc.css '#sec01 ul.profList.btn li img'
  artists_829 = []
  result_829.each do | r |
    artists_829 << r['alt']
  end

  # Pathキーを取得して、[artist名 path_key 日付]でファイル出力
  artists_829.each do | artist |
    name = artist.to_s
    tmp =apk.ask name
    f.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140829"
  end
  
  # HTMLからartist名を取得
  result_830 = doc.css '#sec02 ul.profList.btn li img'
  artists_830 = []
  result_830.each do | r |
    artists_830 << r['alt']
  end

  # Pathキーを取得して、[artist名 path_key 日付]でファイル出力
  artists_830.each do | artist |
    name = artist.to_s
    tmp =apk.ask name
    f.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140830"
  end

  # HTMLからartist名を取得
  result_831 = doc.css '#sec03 ul.profList.btn li img'
  artists_831 = []
  result_831.each do | r |
    artists_831 << r['alt']
  end

  # Pathキーを取得して、[artist名 path_key 日付]でファイル出力
  artists_831.each do | artist |
    name = artist.to_s
    tmp =apk.ask name
    f.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140831"
  end

  f.close
end

################################################
#
# main
#
love_shower_url = 'http://www.sweetloveshower.com/artist/index.html'

LOVE_SHOWER_OUTNAME = './love-shower-2014.artists'

files = [LOVE_SHOWER_OUTNAME]

# 履歴管理用のインスタンスを生成
old_files = []
# 昔のファイルは存在するか？
files.each do |fn|
  if File.exists? fn
    of = fn + '.old'
    old_files << of
    # ファイル名にoldをつけて退避する。
    raise "ファイルコピーに失敗: #{file}" if FileUtils.cp(fn, of)
  end
end

additional_rules = {
}
apk = AskPathKey.new additional_rules
# 履歴を登録
old_files.each { |of| apk.load_history of }

scrape_artists apk, love_shower_url, LOVE_SHOWER_OUTNAME 

# 退避したファイルを削除
old_files.each do |of|
  File.delete of if File.exists? of
end