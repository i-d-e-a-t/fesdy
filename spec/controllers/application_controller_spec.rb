require 'rails_helper'

describe ApplicationController, :type => :controller, :youtube => true do
  let(:max) { ApplicationController::NUM_OF_LIST }
  describe '#get_yt_video_ids' do
    context '「柴犬」を引数に' do
      before :all do
        @parameter = '柴犬'
      end
      context '検索した時' do
        subject {
          ApplicationController.new.send(:get_yt_video_ids, @parameter)
        }
        its(:class) { should eq Array }
        its(:length) { should be <= max }
      end

      context '１回検索済みで、再度検索した時は' do
        before :all do
          @ids = ApplicationController.new.send(:get_yt_video_ids, @parameter)
        end
        subject {
          ApplicationController.new.send(:get_yt_video_ids, @parameter)
        }
        its(:class) { should eq Array }
        its(:length) { should be <= max }
        it { is_expected.not_to eq @ids }
      end
    end
  end
end
