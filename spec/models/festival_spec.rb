require 'rails_helper'

describe Festival, :type => :model do
  context "データがある場合" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @artist = Artist.last
      @music = Music.last
    end
    it "#artistsで出演するアーティストを取得できる" do
      expect(@festival.artists).to eq [@artist]
    end
    it "#setlist(artist)でセットリストを取得できる" do
      expect(@festival.setlist(@artist)).to eq [@music]
    end
  end
end
