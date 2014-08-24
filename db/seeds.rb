# encoding: utf-8

# 一旦削除
Festival.destroy_all
Artist.destroy_all
Appearance.destroy_all
FestivalDate.destroy_all

# ------------------------------------------------------------
#
# サマソニ2014
#

Festival.create do |festival|
  festival.id = 1
  festival.path_key = 'summer-sonic-2014'
  festival.name = 'SUMMER SONIC 2014'
  #festival.start_date = DateTime.new(2014, 8, 16)
  #festival.end_date = DateTime.new(2014, 8, 17)
  festival.official_site = 'http://www.summersonic.com/2014/'
  #festival.place =
  #  "東京：QVCマリンフィールド＆幕張メッセ\n大阪：舞洲サマーソニック大阪特設会場"
end

festival = Festival.last
places = ["東京：QVCマリンフィールド＆幕張メッセ",
          "大阪：舞洲サマーソニック大阪特設会場"]
dates = (DateTime.new(2014, 8, 16)..DateTime.new(2014, 8, 17)).to_a

#
# 日時、場所の登録
#
# 1: tokyo 816
# 2: tokyo 817
# 3: osaka 816
# 4: osaka 817

fdid = 1

places.product(dates).each do |pd|
  place, date = pd
  FestivalDate.create do |festival_date|
    festival_date.id = fdid
    festival_date.festival_id = 1
    festival_date.place = place
    festival_date.date = date
    
    # 日付と場所でパスキーを作成。
    place_key = place.include?("東京") ? "tokyo" : "osaka"
    festival_date.path_key = "#{date.year}-#{date.month}-#{date.day}-#{place_key}"

  end
  fdid += 1
end

#
# 出演者の登録
#

files = {
  tokyo: '/lib/script/summer-sonic-2014.artists.tokyo',
  osaka: '/lib/script/summer-sonic-2014.artists.osaka',
}

# idは連番
artist_id = 1
# 使用済みpath_keyのキャッシュ
path_key_list = []
# path_key_listと同じ並びで、アーティストidをキャッシュ
artist_id_list = []
files.each do |place, file|
  File.open(Rails.root.to_s + file) do |f|
    # 各行に対して繰り返し
    # アーティスト名、パスキー、日付（yyyymmdd）のタブ区切り
    while line = f.gets
      line.chomp!
      artist_data = line.split("\t")
      # festival_dateのidを判定
      fdid = 1
      if place == :tokyo
        fdid = artist_data[2] == "20140816" ? 1 : 2
      else
        fdid = artist_data[2] == "20140816" ? 3 : 4
      end
      # path_keyが等しい場合は「Artistは」登録しない
      unless path_key_list.include? artist_data[1]
        # 重複登録を避けるため、path_keyをリストに保持
        path_key_list.push artist_data[1]
        artist_id_list.push artist_id
        Artist.create do |artist|
          artist.id = artist_id
          artist.name = artist_data[0]
          artist.path_key = artist_data[1]
        end
        # appearance作成のためのartist_id
        # 新規作成なのでそのまま使う
        tmp_aid = artist_id
      else
        # appearance作成のためのartist_id
        # path_key_listにある、つまりすでに存在するArtistの場合、
        # IDは既存のものから取得する。
        tmp_aid = artist_id_list[path_key_list.index(artist_data[1])]
      end
      # 注意：すでに登録されているアーティストであっても、appearanceは登録
      # 「summer-sonic-2014に出演する」レコードを登録
      Appearance.create(
        festival_date_id: fdid,
        artist_id: tmp_aid
      )
      artist_id += 1
    end
  end
end
