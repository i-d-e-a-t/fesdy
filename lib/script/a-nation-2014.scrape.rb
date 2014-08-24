# encoding: utf-8
#
# a-nation2014の出演者を取得するスクリプト。
#
require "nokogiri"
require "open-uri"
require "fileutils"

# パスキー作成モジュールをインクルード
require_relative '../tasks/ask_path_key.rb'


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
def scrape_artists apk, urls, file = nil

  # 出力用ファイルをオープン
  f = File.open(file, 'w')

  # 各日付ごとにartist名を取得し、ファイルに出力する
  urls.each do | date, url |
    puts "date : #{date}".green
    puts "url  : #{url}".green
    begin
      doc = Nokogiri::HTML(open url)
    rescue => e
      puts "#{e.class}".red
      puts e.message.red
      exit 1
    end

    # HTMLからartist名を取得
    result = doc.css "div.artistDetail h3"
    artists = []
    result.each do | r |
      artists << r.content
    end

    # Pathキーを取得して、[artist名 path_key 日付]でファイル出力
    artists.each do | artist |
      name = artist.to_s
      tmp = apk.ask name
      f.puts tmp[0] + "\t" + tmp[1] + "\t" + "#{date}"
    end


  end

  # ファイルクローズ
  f.close
end

#######################################################################
#
# main
#
a_nation_urls = {
                 '20140829' => 'http://a-nation.net/stadium_fes/live/0829.html',
                 '20140830' => 'http://a-nation.net/stadium_fes/live/0830.html',
                 '20140831' => 'http://a-nation.net/stadium_fes/live/0831.html'
                }
A_NATION_OUTNAME = "./a-nation-2014.artists"

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
  '【日本】' => '',
  '(VERBAL/☆Taku Takahashi)' => ''
}
apk = AskPathKey.new additional_rules
# 履歴を登録
old_files.each { |of| apk.load_history of }

# ファイルに出力
scrape_artists apk, a_nation_urls, A_NATION_OUTNAME

# 退避したファイルを削除
old_files.each do |of|
  File.delete of if File.exists? of
end
