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

    it "returns 200 with '/festivals/:exist_key'     request" do
      expect(:get => "/festivals/#{@exist_key}").
        to have_http_status(:ok)

    end

    it "returns 404 with '/festivals/:not_exist_key' request" do
      expect(:get => "/festivals/#{@not_exist_key}").
        to_have_http_status(:not_found)

    end

    it "doesn't catch '/festivals/show' (like RPC)" do
      expect(:get => "/festivals/show").not_to be_routable

    end

    it "returns http success" do
      get 'show'
      expect(response).to be_success
    end

  end

end
