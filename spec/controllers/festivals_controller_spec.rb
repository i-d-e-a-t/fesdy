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

end
