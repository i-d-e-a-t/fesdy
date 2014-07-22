# encoding: utf-8

# 一旦削除
Festival.destroy_all
Artist.destroy_all
Appearance.destroy_all

# ------------------------------------------------------------
#
# サマソニ2014
#

Festival.create do |festival|
  festival.id = 1
  festival.path_key = 'summer-sonic-2014'
  festival.name = 'サマーソニック2014'
  festival.start_date = DateTime.new(2014, 8, 16)
  festival.end_date = DateTime.new(2014, 8, 17)
  festival.official_site = 'http://www.summersonic.com/2014/'
  festival.place =
    "東京：QVCマリンフィールド＆幕張メッセ\n大阪：舞洲サマーソニック大阪特設会場"
end

#
# 出演者
#

File.open(Rails.root.to_s + '/summer-sonic-2014.artists') do |f|
  artist_id = 1
  path_key_list = []
  while line = f.gets
    line.chomp!
    artist_data = line.split("\t")
    # path_keyが等しい場合は登録しない
    unless path_key_list.include? artist_data[1]
      # 重複登録を避けるため、path_keyをリストに保持
      path_key_list.push artist_data[1]
      Artist.create do |artist|
        artist.id = artist_id
        artist.name = artist_data[0]
        artist.path_key = artist_data[1]
      end
      # 「summer-sonic-2014に出演する」レコードを登録
      # TODO: スクリプト内でIDを取得する方法があれば書き換えること
      Appearance.create(
        festival_id: Festival.last.id,
        artist_id: artist_id
      )
      artist_id += 1
    end
  end
end
