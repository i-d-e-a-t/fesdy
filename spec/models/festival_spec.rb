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
    it "can create" do
      result = Festival.create(path_key: 'awesome-fes').save
      expect(result).to eq true
    end
    it "cannnot create same path_key already exists" do
      result = Festival.create(path_key: @festival.path_key).save
      expect(result).to eq false
    end
    it "cannnot create nil path_key" do
      result = Festival.create(path_key: nil).save
      expect(result).to eq false
    end
    it "cannnot create '' path_key" do
      result = Festival.create(path_key: '').save
      expect(result).to eq false
    end
  end
end
