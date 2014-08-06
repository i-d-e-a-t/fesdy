# encoding: utf-8
#
# 複数のテストコードで用いる
# 共通的な処理（データ準備とか）を定義する。
# モジュールは自動でincludeするので
# 各テストコードではメソッドのみ呼ぶこと。
module CommonHelper
  
  # 最低限の情報をもつ各モデルを作成する。
  def help_create_models_for_relations
    festival = Festival.create(
      path_key: 'awesome-festival-2014'
    )
    festival_date = FestivalDate.create(
      date: DateTime.now,
      festival_id: festival.id,
      path_key: '2014-08-06-Chiba'
    )
    artist = Artist.create(
      name: 'すごい奴らfeat.ヤバい奴ら',
      path_key: 'awesome-artist-2014'
    )
    appearance = Appearance.create(
      festival_date_id: festival_date.id,
      artist_id: artist.id
    )
  end
end
