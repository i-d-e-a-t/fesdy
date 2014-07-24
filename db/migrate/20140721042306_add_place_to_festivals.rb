class AddPlaceToFestivals < ActiveRecord::Migration
  def change
    add_column :festivals, :place, :string
  end
end
