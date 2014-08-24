# encoding: utf-8
require 'rails_helper'

describe FestivalsController, :type => :controller do
  describe "GET 'show'" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @exist_key = @festival.path_key
      @not_exist_key = 'it-is-not-festivals-key'
    end

    it "success with '/festivals/:exist_key'" do
      get :show, id: @exist_key
      expect(response.status).to eq 200
      expect(response).to render_template("show")

    end

    it "returns 404 with '/festivals/:not_exist_key'" do
      get :show, id: @not_exist_key
      expect(response.status).to eq 404

    end

    it "catches '/festivals/some-strings'" do
      expect(get: "/festivals/some-strings").to route_to(
        controller: "festivals",
        action: "show",
        id: "some-strings"
      )
    end

  end

  describe "#study" do
    before do
      help_create_models_for_relations
      @festival = Festival.last
      @exist_key = @festival.path_key
      @not_exist_key = 'it-is-not-festivals-key'
      @date = FestivalDate.last
      @exist_date_key = @date.path_key
      @not_exist_date_key = 'it-is-not-festival-dates-key'
      @last_session = session.dup
    end

    #
    # 共通テスト
    #
    # study_target: 予習対象のフェス、またはフェス開催
    shared_examples_for '[予習スタート]' do
      it "成功" do
        expect(response.status).to eq 200
      end
      it "studyを描画" do
        expect(response).to render_template("study")
      end
      it "セッションに予習IDをセットする" do
        expect(session[:study_id]).to eq study_target.path_key.to_s
      end
      it "セッションに予習リストをセットする" do
        expected_length = study_target.artists.count < 10 ? study_target.artists.count - 1 : 9
        expect(session[:study_list].length).to eq expected_length
      end
      it "セッションに保存版の予習リストをセットする" do
        expected_length = study_target.artists.count < 10 ? study_target.artists.count : 10
        expect(session[:study_initial_list].length).to eq expected_length
      end
      it "セッションに次のアーティストの名前が入っている" do
        expect(session[:study_next_artist]).to eq Artist.find(session[:study_list].last).name
      end
      it "セッションに今のアーティストのidが入っている" do
        expect(study_target.artists.all.pluck(:id)).to include session[:study_artist_id]
      end
    end
    shared_examples_for '[予習スタート失敗]' do
      it "失敗" do
        expect(response.status).not_to be :success
      end
      it "セッションに予習IDをセットしない" do
        expect(session[:study_id]).to be nil
      end
      it "セッションに予習リストをセットしない" do
        expect(session[:study_list]).to be nil
      end
      it "セッションに保存版の予習リストをセットしない" do
        expect(session[:study_initial_list]).to be nil
      end
      it "セッションに次のアーティストの名前が入っていない" do
        expect(session[:study_next_artist]).to be nil
      end
      it "セッションに今のアーティストのidが入っていない" do
        expect(session[:study_artist_id]).to be nil
      end
    end
    shared_examples_for '[予習再開失敗]' do
      it "失敗" do
        expect(response.status).not_to be :success
      end
      it "セッションの予習IDが変化しない" do
        expect(session[:study_id]).to eq @last_session[:study_id]
      end
      it "セッションの予習リストが変化しない" do
        expect(session[:study_list]).to eq @last_session[:study_list]
      end
      it "セッションの保存版の予習リストを変化させない" do
        expect(session[:study_initial_list]).to eq @last_session[:study_initial_list]
      end
      it "セッションの次のアーティストの名前が変化しない" do
        expect(session[:study_next_artist]).to eq @last_session[:study_next_artist]
      end
      it "セッションの今のアーティストのidが変化していない" do
        expect(session[:study_artist_id]).to eq @last_session[:study_artist_id]
      end
    end

    #
    # 共通before
    #
    def clear_session; session.each { |k, v| session[k] = nil }; end
    def final_study study_id
      session[:study_id] = study_id
      session[:study_list] = []
      session[:study_next_artist] = nil
      # 最後にpopされるもの
      target = Festival.where(path_key: study_id).last ||
               FestivalDate.where(path_key: study_id).last
      session[:study_initial_list] = target.artists.pluck(:id).slice(1,10)
      session[:study_artist_id] = session[:study_initial_list].first
    end

    #
    # /festivals/:id/study
    #
    context "フェスごとの予習で、" do
      context "セッションがからの場合、" do
        before { clear_session }
        context "存在するフェスにリクエストを送ると" do
          before do
            get :study, id: @exist_key
          end
          let(:study_target) { @festival }
          it_behaves_like '[予習スタート]'
        end
        context "存在しないフェスにリクエストを送ると" do
          before do
            get :study, id: @not_exist_key
          end
          it "404を返却" do
            expect(response.status).to eq 404
          end
          it_behaves_like '[予習スタート失敗]'
        end
      end
      context "最後の１アーティストの場合、" do
        before { final_study @exist_key }
        context "存在するフェスにリクエストを送ると" do
          before do
            get :study, id: @exist_key
          end
          let(:study_target) { @festival }
          it_behaves_like '[予習スタート]'
        end
        context "存在しないフェスにリクエストを送ると" do
          before do
            get :study, id: @not_exist_key
          end
          it_behaves_like '[予習再開失敗]'
        end
      end
    end

    #
    # /festivals/:festival_id/dates/:date_id/study
    #
    context "フェス開催ごとの予習で、" do
      context "セッションがからの場合、" do
        before { clear_session }
        context "存在するフェス開催にリクエストを送ると" do
          before do
            get :study, festival_id: @exist_key, date_id: @exist_date_key
          end
          let(:study_target) { @date }
          it_behaves_like '[予習スタート]'
        end
        context "存在しないフェスにリクエストを送ると" do
          before do
            get :study, festival_id: @not_exist_key, date_id: @exist_date_key
          end
          it_behaves_like "[予習スタート失敗]"
        end
        context "存在しないフェス開催にリクエストを送ると" do
          before do
            get :study, festival_id: @exist_key, date_id: @not_exist_date_key
          end
          it_behaves_like "[予習スタート失敗]"
        end
      end
      context "最後の１アーティストの場合、" do
        before { final_study @exist_key }
        context "存在するフェス開催にリクエストを送ると" do
          before do
            get :study, festival_id: @exist_key, date_id: @exist_date_key
          end
          let(:study_target) { @date }
          it_behaves_like '[予習スタート]'
        end
        context "存在しないフェスにリクエストを送ると" do
          before do
            get :study, festival_id: @not_exist_key, date_id: @exist_date_key
          end
          it_behaves_like "[予習再開失敗]"
        end
        context "存在しないフェス開催にリクエストを送ると" do
          before do
            get :study, festival_id: @exist_key, date_id: @not_exist_date_key
          end
          it_behaves_like "[予習再開失敗]"
        end
      end
    end
  end
end
