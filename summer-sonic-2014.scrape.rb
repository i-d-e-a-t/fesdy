# encoding: utf-8
#
# サマソニ2014の出演者を取得するスクリプト。
# summer-sonic-2014.artists というファイルに1行１アーティストの形式で出力する。
#
require "nokogiri"
require "open-uri"
# パスキー作成モジュールをインクルード
require_relative 'lib/tasks/ask_path_key.rb'


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
def scrape_artists url, file = nil
  puts "url: #{url}".green
  begin
    doc = Nokogiri::HTML(open url)
  rescue => e
    puts "#{e.class}".red
    puts e.message.red
    exit 1
  end

  result_816 = doc.css "#lineupList ul#list816 li:not([class*='ttl'])"
  result_816 = result_816.css "li:not([class='blank'])"

  result_817 = doc.css "#lineupList ul#list817 li:not([class*='ttl'])"
  result_817 = result_817.css "li:not([class='blank'])"

  artists_816 = []
  artists_817 = []
  result_816.each_with_index do |r|
    r = r.content
    if r == "" || nil
      next 
    end
    artists_816.push r
  end
  result_817.each_with_index do |r|
    r = r.content
    if r == "" || nil
      next 
    end
    artists_817.push r
  end
  # 全数を表示
  puts "2014/8/16アーティスト数: #{artists_816.length}".yellow
  artists_816.each_with_index do |r, i|
    print "(#{i + 1}/#{artists_816.length}) ".yellow
    name = r.to_s
    # パスキーを調べる
    tmp = AskPathKey.ask name, {'Opening Act' => ''}
    # タブで区切ってファイルに出力
    file.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140816"
  end
  puts "2014/8/17アーティスト数: #{artists_817.length}".yellow
  artists_817.each_with_index do |r, i|
    print "(#{i + 1}/#{artists_817.length}) ".yellow
    name = r.to_s
    # パスキーを調べる
    tmp = AskPathKey.ask name, {'Opening Act' => ''}
    # タブで区切ってファイルに出力
    file.puts tmp[0] + "\t" + tmp[1] + "\t" + "20140817"
  end
end

#######################################################################
#
# main
#
tokyo_url = "http://www.summersonic.com/2014/lineup/"
osaka_url = "http://www.summersonic.com/2014/lineup/osaka.html"
TOKYO_OUTNAME="summer-sonic-2014.artists.tokyo"
OSAKA_OUTNAME="summer-sonic-2014.artists.osaka"
# ファイルに出力
File.open(TOKYO_OUTNAME, 'w') do |f|
  scrape_artists tokyo_url, f
end
File.open(OSAKA_OUTNAME, 'w') do |f|
  scrape_artists osaka_url, f
end
