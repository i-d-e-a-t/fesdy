require 'nokogiri'
require 'open-uri'
require 'FileUtils'

# todo:出力の色の変更

# urlとcssを指定するruleを渡してスクレイプする
# (xpathでスクレイプする場合は要検討)
def scrape_with_nokogiri(url, rule)
  begin
    doc = Nokogiri::HTML(open url)
  rescue => e
    puts "#{e.class}".red
    puts e.message.red
    exit 1
  end

  result = doc.css rule
end

# ファイル名、アーティストの配列、日付を渡して
# ファイル出力する
def print_to_file(file, artists, date)
  f = File.open(file, 'w')

  artists.each_with_index do |r|
    name = r.to_s
    f.puts name + "\t" + date
  end

  f.close
end

# 既にファイルが存在していたときの履歴管理
def stash_old_files(files)
  old_files =[]

  files.each do |fn|
    if File.exits? fn
      of = fn + '.old'
      old_files << of
      
      raise "ファイルコピーに失敗: #{file}" if FileUtils.cp(fn, of)
    end
  end
end

# 既に存在していたファイルを削除
def delete_old_files
  old_files.each do |of|
    File.delete of if File.exist? of
  end
end
