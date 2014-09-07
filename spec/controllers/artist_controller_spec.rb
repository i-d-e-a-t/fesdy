require 'rails_helper'

describe ArtistController, :type => :controller do

  describe "GET 'show'" do

    before do
      help_create_models_for_relations
      @artist= Artist.last
      @exist_id = @artist.id
      @not_exist_id = '99999'
    end 

    it "success with '/artists/:exist_id'" do
      get :show, id: @exist_id
      expect(response.status).to eq 200 
      expect(response).to render_template("show")
    end
    
    it "return 404 with '/artists/:not_exist_id'" do
      get :show, id: @not_exist_id
      expect(response.status).to eq 404
    end

  end

  describe "#search_itunes" do
    before do
      help_create_models_for_relations
      @artist= Artist.last
      @exist_id = @artist.id
      @not_exist_key = '999999'
    end 
    it "catches '/artists/.../itunes'" do
      expect(:get => "/artists/#{@exist_id}/itunes").to route_to(
        controller: 'artist',
            action: 'search_itunes',
                id: "#{@exist_id}"
      )
    end
  end


end

