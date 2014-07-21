# encoding: utf-8
#
# サマソニ2014の出演者を取得するスクリプト。
# summer-sonic-2014.artists というファイルに1行１アーティストの形式で出力する。
#
require "nokogiri"
require "open-uri"

DEBUG=false

class String
  def c n
    return "\e[#{n}m#{self}\e[0m"
  end
  def red; return self.c 31; end
  def green; return self.c 32; end
  def yellow; return self.c 33; end
end

def scrape_artists url, file = nil
  puts "url: #{url}".green if DEBUG
  begin
    doc = Nokogiri::HTML(open url)
    puts "you got HTML".green if DEBUG
  rescue => e
    puts "#{e.class}".red if DEBUG
    puts e.message.red if DEBUG
    return
  end

  result = doc.css "#lineupList ul li:not([class*='ttl'])"
  result = result.css "li:not([class='blank'])"

  artists = []
  result.each_with_index do |r|
    r = r.content
    if r == "" || nil
      puts "** empty element".yellow if DEBUG
      next 
    end
    artists.push r
  end
  artists.each_with_index do |r, i|
    if DEBUG
      puts i.to_s.yellow + ": " + r.to_s.green
    else
      # デバッグじゃない場合
      file.puts r.to_s
    end
  end
end

tokyo_url = "http://www.summersonic.com/2014/lineup/"
osaka_url = "http://www.summersonic.com/2014/lineup/osaka.html"
if DEBUG
  puts ("-"*70).yellow
  puts " "*20+"tokyo".yellow
  puts ("-"*70).yellow
  scrape_artists tokyo_url
  puts ("-"*70).yellow
  puts " "*20+"osaka".yellow
  puts ("-"*70).yellow
  scrape_artists osaka_url
else
  # デバッグじゃない場合
  File.open('ss2014.txt', 'w') do |f|
    scrape_artists tokyo_url, f
    scrape_artists osaka_url, f
  end
end
