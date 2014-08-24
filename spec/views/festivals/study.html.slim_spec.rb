# encoding: utf-8
require 'rails_helper'

describe "festivals/study.html.slim", :type => :view do
  before do
    # 最低限のレコードを登録
    help_create_models_for_relations
    # コントローラーが設定するインスタンス変数をスタブ
    fes = Festival.last
    artist = fes.artists.last
    assign(:target, fes)
    assign(:artist, artist)
    assign(:yt_video_ids, [1,2,3])
    session[:study_initial_list] = []
  end

  it "no error" do
    render
  end
end
