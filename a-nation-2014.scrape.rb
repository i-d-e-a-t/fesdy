# encoding: utf-8
#
# a-nation2014の出演者を取得するスクリプト。
# summer-sonic-2014.artists というファイルに1行１アーティストの形式で出力する。
#
require "nokogiri"
require "open-uri"
require "fileutils"
#require "FileUtils"

# パスキー作成モジュールをインクルード
require_relative './ask_path_key.rb'


class String
  def c n; "\e[#{n}m#{self}\e[0m"; end
  def red; c 31; end
  def green; c 32; end
  def yellow; c 33; end
end

#######################################################################
#
# アーティストを抽出。
#
def scrape_artists apk, url, file = nil

  # 出力用ファイルをオープン
  f = File.open(file, 'w')

  puts "url: #{url}".green

#  begin
    doc = Nokogiri::HTML(open url)
#  rescue => e
#   puts "#{e.class}".red
#    puts e.message.red
#    exit 1
#  end
  result = doc.css "#contentArtist div.boxArtist div.artist span"

  artists = []  
  result.each do | r |
    artists << r.content
  end

  # 全数を表示
  puts "アーティスト数: #{artists.length}".yellow
  
  

=begin
  # 全数を表示
  puts "2014/8/16アーティスト数: #{artists_816.length}".yellow
  artists_816.each_with_index do |r, i|
    print "(#{i + 1}/#{artists_816.length}) ".yellow
    name = r.to_s
    # パスキーを調べる
    tmp = apk.ask name
    # タブで区切ってファイルに出力
    f.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140816"
  end
  puts "2014/8/17アーティスト数: #{artists_817.length}".yellow
  artists_817.each_with_index do |r, i|
    print "(#{i + 1}/#{artists_817.length}) ".yellow
    name = r.to_s
    # パスキーを調べる
    tmp = apk.ask name
    # タブで区切ってファイルに出力
    f.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140817"
  end
=end
  # ファイルクローズ
  f.close
end

#######################################################################
#
# main
#
a_nation_url = "http://a-nation.net/artist/"
A_NATION_OUTNAME="a-nation-2014.artists"

files = [A_NATION_OUTNAME]

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
  '【台湾】' => '',
  '【日本】' => '',
  '【韓国】' => '',
}
apk = AskPathKey.new additional_rules
# 履歴を登録
old_files.each { |of| apk.load_history of }

# ファイルに出力
scrape_artists apk, a_nation_url, A_NATION_OUTNAME

# 退避したファイルを削除
old_files.each do |of|
  File.delete of if File.exists? of
end
