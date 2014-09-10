require 'nokogiri'
require 'open-uri'
require 'fileutils'

# フェス情報をスクレイピングして、
# artistsファイルに出力する手助けをするモジュール。
#
# 本ファイルをrequireすることで
# 自動的にincludeされるので注意
module ScrapeHelper
  # ファイル退避、スクレイピングを一括で行うメソッド
  def generate_artists_file(info)
    # ファイルを逃がす
    stash_old_file info[:output]
    # リクエストしてスクレイピング
    html_nodes = scrape_with_nokogiri info[:url], info[:css]
    # 結果をファイルに出力
    print_to_file info[:output], html_nodes.map(&:content), info[:date_key]
    # ファイルを消す
    delete_old_file info[:output] + '.old'
  rescue => e
    # エラーが起きてたらエラー出力
    puts e
    # アウトプットの場所を示す
    puts
    puts "  but... ScrapeHelper stashed old file at '#{info[:output]}.old'"
    puts
  end

  # urlとcssを指定するruleを渡してスクレイプする
  # (xpathでスクレイプする場合は要検討)
  def scrape_with_nokogiri(url, rule)
    nokogiri_html(url).css rule
  end

  # urlを渡すと、HTMLを取得し、
  # Nokogiri::HTML::Document のインスタンスを返却
  def nokogiri_html(url)
    Nokogiri::HTML(open url)
  end

  # ファイル名、アーティストの配列、日付を渡して
  # ファイル出力する
  def print_to_file(file, artists, date)
    File.open(file, 'a') do |f|
      artists.each do |r|
        name = r.to_s
        f.puts name.strip + "\t" + date
      end
    end
  end

  # 既にファイルが存在していたときの履歴管理
  def stash_old_file(filename)
    return unless File.exist? filename
    File.rename(filename, old_name_of(filename))
  rescue => e
    puts "ファイル名変更に失敗: #{file}"
    puts e.message
  end

  # 既に存在していたファイルを削除
  def delete_old_file(filename)
    old_fn = old_name_of filename
    File.delete old_fn if File.exist? old_fn
  end

  # 古いファイルの名前を返す
  def old_name_of(name)
    name + '.old'
  end
end

#
# 自動include
#
include ScrapeHelper
