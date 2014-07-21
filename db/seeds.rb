# encoding: utf-8

# 一旦削除
Festival.destroy_all
Artist.destroy_all
Appearance.destroy_all

# ------------------------------------------------------------
#
# サマソニ2014
#

Festival.create(
  path_key: 'summer-sonic-2014',
  name: 'サマーソニック2014',
  start_date: DateTime.new(2014, 8, 16),
  end_date: DateTime.new(2014, 8, 17),
  official_site: 'http://www.summersonic.com/2014/',
  place:
    '東京：QVCマリンフィールド＆幕張メッセ,大阪：舞洲サマーソニック大阪特設会場'
)

#
# 出演者
#

File.open(Rails.root.to_s + '/summer-sonic-2014.artists') do |f|
  artist_id_count = 1
  path_key_list = []
  while line = f.gets
    line.chomp!
    artist = line.split("\t")
    # path_keyが等しい場合は登録しない
    unless path_key_list.include? artist[1]
      # 重複登録を避けるため、path_keyをリストに保持
      path_key_list.push artist[1]
      Artist.create(
        name: artist[0],
        path_key: artist[1]
      )
      # 「summer-sonic-2014に出演する」レコードを登録
      # TODO: スクリプト内でIDを取得する方法があれば書き換えること
      Appearance.create(
        festival_id: 1,
        artist_id: artist_id_count
      )
      artist_id_count += 1
    end
  end
end
