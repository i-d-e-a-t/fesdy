require 'rails_helper'

describe FestivalDate, :type => :model do
  #
  # 共通のコンテキスト
  #
  shared_context "データがある場合" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @date = @festival.festival_dates.last
    end
  end

  describe '#to_title' do
    include_context 'データがある場合'
    subject { @date.to_title }
    let(:fes_name) { @festival.name }
    it { should eq fes_name }
  end
  
  describe '#to_detail_for_title' do
    include_context 'データがある場合'
    subject { @date.to_detail_for_title }
    let(:fes_name) { @festival.name }
    let(:year)     { @date.date.year.to_s }
    let(:month)    { @date.date.month.to_s }
    let(:day)      { @date.date.day.to_s }
    let(:place)    { @date.place }
    it { should_not include fes_name }
    it { should include year }
    it { should include month }
    it { should include day }
    it { should include place }
  end
end
