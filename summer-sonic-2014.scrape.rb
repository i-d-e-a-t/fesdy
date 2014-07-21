# encoding: utf-8
#
# サマソニ2014の出演者を取得するスクリプト。
# summer-sonic-2014.artists というファイルに1行１アーティストの形式で出力する。
#
require "nokogiri"
require "open-uri"
# パスキー作成モジュールをインクルード
require_relative 'lib/tasks/ask_path_key.rb'

OUTNAME="summer-sonic-2014.artists"

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

  result = doc.css "#lineupList ul li:not([class*='ttl'])"
  result = result.css "li:not([class='blank'])"

  artists = []
  result.each_with_index do |r|
    r = r.content
    if r == "" || nil
      next 
    end
    artists.push r
  end
  # 全数を表示
  puts "アーティスト数: #{artists.length}".yellow
  artists.each_with_index do |r, i|
    print "(#{i + 1}/#{artists.length}) ".yellow
    name = r.to_s
    # パスキーを調べる
    result = AskPathKey.ask name, {'Opening Act' => ''}
    # タブで区切ってファイルに出力
    file.puts result[0] + "\t" + result[1]
  end
end

#######################################################################
#
# main
#
tokyo_url = "http://www.summersonic.com/2014/lineup/"
osaka_url = "http://www.summersonic.com/2014/lineup/osaka.html"
# ファイルに出力
File.open(OUTNAME, 'w') do |f|
  scrape_artists tokyo_url, f
  scrape_artists osaka_url, f
end

