# encoding: utf-8
require 'rails_helper'

describe FestivalsController, :type => :controller do

  describe "GET 'show'" do
    it "catches '/festivals/:festival_key' (like REST)"
    it "doesn't catch '/festivals/show' (like RPC)"
    it "returns http success" do
      get 'show'
      expect(response).to be_success
    end
  end

end
