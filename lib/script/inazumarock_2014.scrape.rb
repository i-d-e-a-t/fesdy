# イナズマロックフェス2014の出演者を取得するスクリプト
# inazumarock-2014.artists というファイルに
# 1行1アーティストの形式で出力する。

require 'nokogiri'
require 'open-uri'
require 'FileUtils'
require 'pry'

# パスキー作成モジュールをインクルード
require_relative '../tasks/ask_path_key.rb'

# Stringに色つけるメソッド追加
class String
  def c(n)
    "\e[#{n}m#{self}\e[0m"
  end

  def red
    c 31
  end

  def green
    c 32
  end

  def yellow
    c 33
  end
end

###########
#
# アーティスト抽出
#
def scrape_artists(apk, url, file)
  # 出力用ファイルをオープン
  File.open(file, 'w') do |f|
    scrape_artist_with_file apk, url, f
    # どうやっても取得できなかったので追加
    puts_artist f, apk, '松崎しげる', '20140914'
    puts_artist f, apk, 'Half time Old', '20140914'
    # 手で作った風神ステージ用ファイルから各行を読込
    load_fujin_stage f
  end
end

def load_fujin_stage(f)
  File.open('./lib/script/inazumarock-2014.fujin.artists') do |ff|
    fujin = ff.read
    fujin.lines.each do |fl|
      next if fl.split("\t").length != 3
      f.puts fl
    end
  end
end

def scrape_artist_with_file(apk, url, f)
  # urlからnokogiriオブジェクト取得
  doc = nokogiri(url)

  # HTMLからartist名を取得
  # １つ目が9/13、２つ目が9/14
  dates = %w( 20140913 20140914 )
  uls = doc.css '#artistArea ul.artists'
  uls.each_with_index do | ul, i |
    artists = []
    date_string = dates[i]
    ul.css('li a img').each { |img| artists << img['alt'] }
    # Pathキーを取得し、[artist名 path_key 日付]で出力
    artists.each { | artist | puts_artist f, apk, artist, date_string }
  end
end

def puts_artist(file, apk, name, date_string)
  return if name == ''
  name, path_key = apk.ask name.to_s
  file.puts name + "\t" + path_key + "\t" + date_string
end

# HTMLを取得して、nokogiriのオブジェクトを返却
def nokogiri(url)
  puts "url: #{url}.green"
  doc = Nokogiri::HTML(open url)
rescue => e
  puts "#{e.class}".red
  puts e.message.red
  exit 1
  doc
end

################################################
#
# main
#
target_fes_url = 'http://inazumarock.com/'

OUTPUT_FILENAME = './inazumarock-2014.artists'

files = [OUTPUT_FILENAME]

# 履歴管理用のインスタンスを生成
old_files = []
# 昔のファイルは存在するか？
files.each do |fn|
  next unless File.exist? fn
  of = fn + '.old'
  old_files << of
  # ファイル名にoldをつけて退避する。
  fail "ファイルコピーに失敗: #{file}" if FileUtils.cp(fn, of)
end

# 他のフェスのファイルからも読み込む
Dir.glob('lib/script/*artists*').each do |path|
  old_files << path
end

additional_rules = {}

apk = AskPathKey.new additional_rules
# 履歴を登録
old_files.each { |of| apk.load_history of }

scrape_artists apk, target_fes_url, OUTPUT_FILENAME

# 退避したファイルを削除
stashed_file = OUTPUT_FILENAME + '.old'
File.delete stashed_file if File.exist?(stashed_file)
