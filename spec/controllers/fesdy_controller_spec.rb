require 'rails_helper'

RSpec.describe FesdyController, :type => :controller do

  describe "GET 'index'" do
    it "catches '/'" do
      expect(:get => "/").to route_to(
        :controller => "fesdy",
        :action => "index"
      )
    end
    it "catches '/fesdy'" do
      expect(:get => "/").to route_to(
        :controller => "fesdy",
        :action => "index"
      )
    end
    it "doesn't catch '/fesdy/index'" do
      expect(:get => "/fesdy/index").not_to be_routable
    end
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

end
