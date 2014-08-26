# spac love showerの出演者を取得するスクリプト
# love-shower-2014.artists というファイルに1行1アーティストの形式で出力する。

require 'nokogiri'
require 'open-uri'
require 'FileUtils'

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
  result_829 = doc.css '#sec01 ul.profList.btn li'

  # test
  p result_829

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
    railse "ファイルコピーに失敗: #{file}" if FileUtils.cp(fn, of)
  end
end

additional_rules = {
}
apk = AskPathKey.new additional_rules

scrape_artists apk, love_shower_url, LOVE_SHOWER_OUTNAME 
