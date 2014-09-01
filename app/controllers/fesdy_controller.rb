# encoding: utf-8
class FesdyController < ApplicationController
  def index
  end

  #
  # itunesを検索し、パーシャルなHTMLで返却する。
  #
  def search_itunes
    render :text => params[:keyword]
  end
end
