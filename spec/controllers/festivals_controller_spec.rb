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
    context "フェスごとの予習(セッション情報なし)" do
      before do
        help_create_models_for_relations
        @festival = Festival.last
        @exist_key = @festival.path_key
        @not_exist_key = 'it-is-not-festivals-key'
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
        expect(response.status).to eq 200
        expect(response).to render_template("study")
        expect(session[:study_id]).to eq @exist_key.to_s
        expect(session[:study_list].class).to be Array
        # このテストでは１件だけなので、sessionにはから配列が入る
        expect(session[:study_list].length).to eq 0
      end
    end
  end

end
