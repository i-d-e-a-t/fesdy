# encoding: utf-8
require 'rails_helper'

describe Festival, :type => :model do
  context "データがある場合" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @artist = Artist.last
    end
    it "#artistsで出演するアーティストを取得できる" do
      expect(@festival.artists).to eq [@artist]
    end
  end
end
