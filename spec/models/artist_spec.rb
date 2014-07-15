# encoding: utf-8
require 'rails_helper'

describe Artist, :type => :model do
  context "festival, artist, appearance がある場合" do
    before do
      @fes = Festival.create()
      @artist = Artist.create()
      @appearance = Appearance.create(
        festival_id: @fes.id,
        artist_id: @artist.id
      )
    end
    it "#festivalsで出演するフェスを取得できる" do
      expect(@artist.festivals).to eq [@fes]
    end
  end
end
