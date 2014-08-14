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
    end
    #
    # /festivals/:id/study
    #
    context "フェスごとの予習で、" do
      context "セッションがからの場合、" do
        before do
          session.each { |k, v| session[k] = nil }
        end

        it "success with '/festivals/:exist_key/study'" do
          get :study, id: @exist_key
          expect(response.status).to eq 200
          expect(response).to render_template("study")
        end
        it "returns 404 with '/festivals/:not_exist_key/study'" do
          get :study, id: @not_exist_key
          expect(response.status).to eq 404
          expect(session[:study_id]).to be nil
          expect(session[:study_list]).to be nil
        end
        it "セッションに予習情報をセットする" do
          get :study, id: @exist_key
          expect(session[:study_id]).to eq @exist_key.to_s
          expected_length = @festival.artists.count < 10 ? @festival.artists.count - 1 : 9
          expect(session[:study_list].length).to eq expected_length
        end
        it "セッションに次のアーティストの名前が入っている" do
          pending # TODO
          get :study, id: @exist_key
          expect(@festival.artists.all.pluck(:name)).to include session[:study_next_artist]
        end
      end
      context "最後の１アーティストの場合、" do
        before do
          session[:study_id] = @exist_key
          session[:study_list] = []
        end
        it "success with '/festivals/:exist_key/study'" do
          get :study, id: @exist_key
          expect(response.status).to eq 200
          expect(response).to render_template("study")
        end
        it "returns 404 with '/festivals/:not_exist_key/study'" do
          get :study, id: @not_exist_key
          expect(response.status).to eq 404
          expect(session[:study_id]).to eq @exist_key
          expect(session[:study_list]).to eq []
        end
        it "セッションにあらたな予習情報をセットする" do
          get :study, id: @exist_key
          expect(session[:study_id]).to eq @exist_key.to_s
          expected_length = @festival.artists.count < 10 ? @festival.artists.count - 1 : 9
          expect(session[:study_list].length).to eq expected_length
        end
        it "セッションに次のアーティストの名前が入っている" do
          pending # TODO
          get :study, id: @exist_key
          expect(@festival.artists.all.pluck(:name)).to include session[:study_next_artist]
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
          pending # TODO
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
          pending # TODO
          get :study, festival_id: @exist_key, date_id: @exist_date_key
          expect(@date.artists.all.pluck(:name)).to include session[:study_next_artist]
        end
      end
    end
  end

end
