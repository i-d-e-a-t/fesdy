require 'rails_helper'

describe Music, :type => :model do
  context "データがある場合" do
    before do
      help_create_models_for_relations
      @music = Music.last
      @artist = Artist.last
    end
    it "#artistでアーティストを取得できる" do
      expect(@music.artist).to eq @artist
    end
  end
end
