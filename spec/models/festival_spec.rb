require 'rails_helper'

describe Festival, :type => :model do
  #
  # 共通のコンテキスト
  #
  shared_context "データがある場合" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @artist = Artist.last
    end
  end

  shared_context "開始日の異なる5つのフェスがある場合" do
    before do
      help_fes_order 5, 5 # 5フェス、各5日程
    end
  end

  describe "#sort" do
    context '引数なしのとき、' do
      context do
        include_context "開始日の異なる5つのフェスがある場合"
        subject { Festival.sort }
        its(:length) { should eq Festival.count }
        it "開始日が新しい順に並んでいる" do
          should eq Festival.all.reverse
        end
      end
      context 'fesが0件の時' do
        subject { Festival.sort }
        it { should eq [] }
      end
    end
  end

  describe '#to_title' do
    include_context 'データがある場合'
    subject { @festival.to_title }
    let(:fes_name) { @festival.name }
    it { should eq fes_name }
  end

  describe '#to_detail_for_title' do
    include_context 'データがある場合'
    subject { @festival.to_detail_for_title }
    it { should be nil }
  end

  describe '#artists' do
    include_context 'データがある場合'
    it "#artistsで出演するアーティストを取得できる" do
      expect(@festival.artists).to eq Artist.all.to_a
    end
  end

  describe '新規作成の際、' do
    include_context 'データがある場合'
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
