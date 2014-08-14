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

  describe "GET study" do
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

    # 共通テスト
    shared_examples_for 'start study' do
      it "成功" do
        expect(response.status).to eq 200
      end
      it "studyを描画" do
        expect(response).to render_template("study")
      end
      it "セッションに予習IDをセットする" do
        expect(session[:study_id]).to eq @exist_key.to_s
      end
      it "セッションに予習リストをセットする" do
        expected_length = @festival.artists.count < 10 ? @festival.artists.count - 1 : 9
        expect(session[:study_list].length).to eq expected_length
      end
      it "セッションに次のアーティストの名前が入っている" do
        expect(@festival.artists.all.pluck(:name)).to include session[:study_next_artist]
      end
    end
    shared_examples_for 'start study failed' do
      it "失敗" do
        expect(response.status).not_to be :success
      end
      it "セッションに予習IDをセットしない" do
        expect(session[:study_id]).to be nil
      end
      it "セッションに予習リストをセットしない" do
        expect(session[:study_list]).to be nil
      end
      it "セッションに次のアーティストの名前が入っていない" do
        expect(session[:study_next_artist]).to be nil
      end
    end
    shared_examples_for 'restart study failed' do
      it "失敗" do
        expect(response.status).not_to be :success
      end
      it "セッションの予習IDが変化しない" do
        expect(session[:study_id]).to eq @last_session[:study_id]
      end
      it "セッションの予習リストが変化しない" do
        expect(session[:study_list]).to eq @last_session[:study_list]
      end
      it "セッションの次のアーティストの名前が変化しない" do
        expect(session[:study_next_artist]).to eq @last_session[:study_next_artist]
      end
    end

    #
    # /festivals/:id/study
    #
    context "フェスごとの予習で、" do
      context "セッションがからの場合、" do
        before do
          session.each { |k, v| session[k] = nil }
        end
        context "存在するフェスにリクエストを送ると" do
          before do
            get :study, id: @exist_key
          end
          it_behaves_like 'start study'
        end
        context "存在しないフェスにリクエストを送ると" do
          before do
            get :study, id: @not_exist_key
          end
          it "404を返却" do
            expect(response.status).to eq 404
          end
          it_behaves_like 'start study failed'
        end
      end
      context "最後の１アーティストの場合、" do
        before do
          session[:study_id] = @exist_key
          session[:study_list] = []
          session[:study_next_artist] = nil
        end
        context "存在するフェスにリクエストを送ると" do
          before do
            get :study, id: @exist_key
          end
          it_behaves_like 'start study'
        end
        context "存在しないフェスにリクエストを送ると" do
          before do
            get :study, id: @not_exist_key
          end
          it_behaves_like 'restart study failed'
        end
      end
    end

    #
    # /festivals/:festival_id/dates/:date_id/study
    #
    context "フェス開催ごとの予習で、" do
      context "セッションがからの場合、" do
        before do
          session.each { |k, v| session[k] = nil }
        end

        it "success with '/festivals/:exist_key/dates/:exist_date_key/study'" do
          get :study, festival_id: @exist_key, date_id: @exist_date_key
          expect(response.status).to eq 200
          expect(response).to render_template("study")
        end
        it "returns 404 with '/festivals/:not_exist_key/dates/:exist_date_key/study'" do
          get :study, festival_id: @not_exist_key, date_id: @exist_date_key
          expect(response.status).to eq 404
          expect(session[:study_id]).to be nil
          expect(session[:study_list]).to be nil
        end
        it "returns 404 with '/festivals/:exist_key/dates/:not_exist_date_key/study'" do
          get :study, festival_id: @exist_key, date_id: @not_exist_date_key
          expect(response.status).to eq 404
          expect(session[:study_id]).to be nil
          expect(session[:study_list]).to be nil
        end
        it "セッションに予習情報をセットする" do
          get :study, festival_id: @exist_key, date_id: @exist_date_key
          expect(session[:study_id]).to eq @exist_date_key.to_s
          expected_length = @date.artists.count < 10 ? @date.artists.count - 1 : 9
          expect(session[:study_list].length).to eq expected_length
        end
        it "セッションに次のアーティストの名前が入っている" do
          get :study, festival_id: @exist_key, date_id: @exist_date_key
          expect(@date.artists.all.pluck(:name)).to include session[:study_next_artist]
        end
      end
      context "最後の１アーティストの場合、" do
        before do
          session[:study_id] = @exist_date_key
          session[:study_list] = []
        end
        it "success with '/festivals/:exist_key/dates/:exist_date_key/study'" do
          get :study, festival_id: @exist_key, date_id: @exist_date_key
          expect(response.status).to eq 200
          expect(response).to render_template("study")
        end
        it "returns 404 with '/festivals/:not_exist_key/dates/:exist_date_key/study'" do
          get :study, festival_id: @not_exist_key, date_id: @exist_date_key
          expect(response.status).to eq 404
          expect(session[:study_id]).to eq @exist_date_key
          expect(session[:study_list]).to eq []
        end
        it "returns 404 with '/festivals/:exist_key/dates/:not_exist_date_key/study'" do
          get :study, festival_id: @exist_key, date_id: @not_exist_date_key
          expect(response.status).to eq 404
          expect(session[:study_id]).to eq @exist_date_key
          expect(session[:study_list]).to eq []
        end
        it "セッションに予習情報をセットする" do
          get :study, festival_id: @exist_key, date_id: @exist_date_key
          expect(session[:study_id]).to eq @exist_date_key.to_s
          expected_length = @date.artists.count < 10 ? @date.artists.count - 1 : 9
          expect(session[:study_list].length).to eq expected_length
        end
        it "セッションに次のアーティストの名前が入っている" do
          get :study, festival_id: @exist_key, date_id: @exist_date_key
          expect(@date.artists.all.pluck(:name)).to include session[:study_next_artist]
        end
      end
    end
  end

end
