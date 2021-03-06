# baycamp 2014 の出演者を取得するスクリプト
# baycamp-2014.artists というファイルに1行1アーティストの形式で出力する。

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

  puts "url: #{url}".green
  begin
    doc = Nokogiri::HTML(open url)
  rescue => e
    puts "#{e.class}".red
    puts e.message.red
    exit 1
  end

  # HTMLからartist名を取得
  result = doc.css 'div#page-container h2 a'
  artists = []
  result.each do | r |
    artists << r.content
  end

  # Pathキーを取得して、[artist名 path_key 日付]でファイル出力
  artists.each do | artist |
    name = artist.to_s
    tmp = apk.ask name
    f.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140906"
  end

  f.close
end

################################################
#
# main
#
target_url = 'http://baycamp.net/2014/?page_id=350'

OUTPUT_FILENAME = './baycamp-2014.artists'

files = [OUTPUT_FILENAME]

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

scrape_artists apk, target_url, OUTPUT_FILENAME

# 退避したファイルを削除
old_files.each do |of|
  File.delete of if File.exists? of
end
