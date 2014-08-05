# encoding: utf-8
require 'rails_helper'

describe "fesdy/index.html.slim", :type => :view do

  before do
    # 最低限のレコードを登録
    help_create_models_for_relations
    # コントローラーが設定するインスタンス変数をスタブ
    assign(:festivals,   @festivals = Festival.all)
  end

  # renderで描画。
  # エラーがある場合例外が発生するのでテストに失敗する。
  # エラーがない場合テストに成功する。
  it "no error" do
    render
  end
end
