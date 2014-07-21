class AddPathKeyToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :path_key, :string
  end
end
