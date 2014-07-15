# encoding: utf-8
require 'rails_helper'

describe Artist, :type => :model do
  context "データがある場合" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @artist = Artist.last
      @music = Music.last
    end
    it "#festivalsで出演するフェスを取得できる" do
      expect(@artist.festivals).to eq [@festival]
    end
    it "#musicsで曲を取得できる" do
      expect(@artist.musics).to eq [@music]
    end
    it "#setlist(fes)でセットリストを取得できる"
  end
end
