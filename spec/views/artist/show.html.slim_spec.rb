# encoding: utf-8
require 'rails_helper'

describe "artist/show.html.slim", :type => :view do

  before do
    # 最低限のレコードを登録
    help_create_models_for_relations
    # コントローラーが設定するインスタンス変数をスタブ
    assign(:artist,   @artist = Artist.all.last)
    assign(:yt_video_ids, [1, 2, 3])
  end

  # renderで描画。
  # エラーがある場合例外が発生するのでテストに失敗する。
  # エラーがない場合テストに成功する。
  it "no error" do
    render
  end

  it "アーティスト名が出ること" do
    render
    expect(response).to match @artist.name
  end

end
