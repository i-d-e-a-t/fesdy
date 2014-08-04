class AddPathKeyToFestivalDates < ActiveRecord::Migration
  def change
    add_column :festival_dates, :path_key, :string
  end
end
