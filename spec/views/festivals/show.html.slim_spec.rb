# encoding: utf-8
require 'rails_helper'

describe "festivals/show.html.slim", :type => :view do

  before do
    # 最低限のレコードを登録
    help_create_models_for_relations
    # コントローラーが設定するインスタンス変数をスタブ
    assign(:festival,   @festival = Festival.all.last)
    assign(:dates,      @dates = @festival.festival_dates)
    assign(:start_date, @dates.first)
    assign(:end_date,   @dates.first)
    assign(:places,     @dates.collect { |d| d.place })
  end

  # renderで描画。
  # エラーがある場合例外が発生するのでテストに失敗する。
  # エラーがない場合テストに成功する。
  it "no error" do
    render
  end

end
