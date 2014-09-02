# encoding: utf-8
require 'rails_helper'

describe Artist, :type => :model do
  context "データがある場合" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @artist = Artist.last
    end
    it "#festivalsで出演するフェスを取得できる" do
      expect(@artist.festivals).to eq [@festival]
    end
    it "can create" do
      result = Artist.create(name: '黄泉平坂47').save
      expect(result).to eq true
    end
  end
end
