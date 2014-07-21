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
      result = Artist.create(path_key: 'awesome-artist').save
      expect(result).to eq true
    end
    it "cannnot create same path_key already exists" do
      result = Artist.create(path_key: @artist.path_key).save
      expect(result).to eq false
    end
    it "cannnot create nil path_key" do
      result = Artist.create(path_key: nil).save
      expect(result).to eq false
    end
    it "cannnot create '' path_key" do
      result = Artist.create(path_key: '').save
      expect(result).to eq false
    end
  end
end
