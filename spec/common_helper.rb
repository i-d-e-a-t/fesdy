# encoding: utf-8
#
# 複数のテストコードで用いる
# 共通的な処理（データ準備とか）を定義する。
# モジュールは自動でincludeするので
# 各テストコードではメソッドのみ呼ぶこと。
module CommonHelper
  
  # 日付による順序を見るためのfestivalとfestival_date
  def help_fes_order fes_num, date_num
    fes_num.times do |i|
      festival = Festival.create(
        name: "すごいフェス#{i}",
        path_key: "awesome-festival-#{i}"
      )
      date_num.times do |j|
        festival_date = FestivalDate.create(
          place: "すごいメッセ#{i}-#{j}",
          date: DateTime.now + j, # 古い順に登録する
          festival_id: festival.id,
          path_key: "2014-08-06-Chiba#{i}-#{j}"
        )
      end
    end
  end

  # 最低限の情報をもつ各モデルを作成する。
  def help_create_models_for_relations
    festival = Festival.create(
      name: 'すごいフェス',
      path_key: 'awesome-festival-2014'
    )
    festival_date = FestivalDate.create(
      place: 'すごいメッセ',
      date: DateTime.now,
      festival_id: festival.id,
      path_key: '2014-08-06-Chiba'
    )
    artists = []
    artists << Artist.create(
      name: 'すごい奴らfeat.ヤバい奴ら',
      path_key: 'awesome-artist-2014'
    )
    artists << Artist.create(
      name: 'amazing Artist',
      path_key: 'amazing-artist'
    )
    artists.each do |artist|
      Appearance.create(
        festival_date_id: festival_date.id,
        artist_id: artist.id
      )
    end
  end
end
