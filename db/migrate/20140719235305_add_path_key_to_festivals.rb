class AddPathKeyToFestivals < ActiveRecord::Migration
  def change
    add_column :festivals, :path_key, :string
  end
end
