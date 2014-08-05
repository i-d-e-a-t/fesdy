# encoding: utf-8
require 'rails_helper'

describe "fesdy/index.html.slim", :type => :view do
  # renderで描画。
  # エラーがある場合例外が発生するのでテストに失敗する。
  # エラーがない場合テストに成功する。
  it "no error" do
    render
  end
end
