require 'nokogiri'
require 'open-uri'
require 'fileutils'

# フェス情報をスクレイピングして、
# artistsファイルに出力する手助けをするモジュール。
#
# 本ファイルをrequireすることで
# 自動的にincludeされるので注意
module ScrapeHelper
  # urlとcssを指定するruleを渡してスクレイプする
  # (xpathでスクレイプする場合は要検討)
  def scrape_with_nokogiri(url, rule)
    begin
      doc = Nokogiri::HTML(open url)
    rescue => e
      puts "#{e.class}"
      puts e.message
      exit 1
    end

    doc.css rule
  end

  # ファイル名、アーティストの配列、日付を渡して
  # ファイル出力する
  def print_to_file(file, artists, date)
    f = File.open(file, 'a')

    artists.each_with_index do |r|
      name = r.to_s
      f.puts name + "\t" + date
    end

    f.close
  end

  # 既にファイルが存在していたときの履歴管理
  def stash_old_file(file)
    return unless File.exist? file
    of = file + '.old'
    begin
      File.rename(file, of)
    rescue => e
      puts "ファイル名変更に失敗: #{file}"
      puts e.message
    end
  end

  # 既に存在していたファイルを削除
  def delete_old_file(file)
    old_fn = file + '.old'
    File.delete old_fn if File.exist? old_fn
  end
end

#
# 自動include
#
include ScrapeHelper
