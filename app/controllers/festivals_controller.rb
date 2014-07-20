# encoding: utf-8
class FestivalsController < ApplicationController
  before_filter :prepare_festival,
    only: :show

  def show
    render status: :not_found if @festival.nil?
  end

  private
  #
  # パスパラメーターidからfestivalを検索する
  #
  def prepare_festival
    fs = Festival.where(path_key: params[:id])
    # 検索結果0件の場合はnilになる。
    @festival = fs.last
  end
end
