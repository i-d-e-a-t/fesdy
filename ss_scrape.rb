# encoding: utf-8
require "nokogiri"
require "open-uri"


class String
  def c n
    return "\e[#{n}m#{self}\e[0m"
  end
  def red; return self.c 31; end
  def green; return self.c 32; end
  def yellow; return self.c 33; end
end



def print_artists url
  puts "url: #{url}".green
  begin
    doc = Nokogiri::HTML(open url)
    puts "you got HTML".green
  rescue => e
    puts "#{e.class}".red
    puts e.message.red
    return
  end

  result = doc.css "#lineupList ul li:not([class*='ttl'])"
  result = result.css "li:not([class='blank'])"

  artists = []
  result.each_with_index do |r|
    r = r.content
    if r == "" || nil
      puts "** empty element".yellow
      next 
    end
    artists.push r
  end
  artists.each_with_index do |r, i|
    puts i.to_s.yellow + ": " + r.to_s.green
  end
end

tokyo_url = "http://www.summersonic.com/2014/lineup/"
osaka_url = "http://www.summersonic.com/2014/lineup/osaka.html"


puts ("-"*70).yellow
puts " "*20+"tokyo".yellow
puts ("-"*70).yellow
print_artists tokyo_url
puts ("-"*70).yellow
puts " "*20+"osaka".yellow
puts ("-"*70).yellow
print_artists osaka_url

