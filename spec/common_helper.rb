# encoding: utf-8
#
# 複数のテストコードで用いる
# 共通的な処理（データ準備とか）を定義する。
# モジュールは自動でincludeするので
# 各テストコードではメソッドのみ呼ぶこと。
module CommonHelper
  
  # 最低限の情報をもつ各モデルを作成する。
  # Festivalのオブジェクトは@festivalで利用可能
  def help_create_models_for_relations
    festival = Festival.create()
    artist = Artist.create()
    appearance = Appearance.create(
      festival_id: festival.id,
      artist_id: artist.id
    )
    music = Music.create(
      artist_id: artist.id
    )
    program = Program.create(
      appearance_id: appearance.id,
      music_id: music.id
    )
  end
end
