require 'rails_helper'

describe Festival, :type => :model do
  context "festival, artist, appearance がある場合" do
    before do
      @fes = Festival.create()
      @artist = Artist.create()
      @appearance = Appearance.create(
        festival_id: @fes.id,
        artist_id: @artist.id
      )
    end
    it "#artistsで出演するアーティストを取得できる" do
      expect(@fes.artists).to eq [@artist]
    end
  end
end
