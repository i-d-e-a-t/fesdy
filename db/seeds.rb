# encoding: utf-8

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
  while name = f.gets
    name.chomp!
    artist = name.split("\t")
    Artist.create(
      name: artist[0],
      path_key: artist[1]
    )
  end
end
