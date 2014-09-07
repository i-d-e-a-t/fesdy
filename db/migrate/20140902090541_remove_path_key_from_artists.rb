class RemovePathKeyFromArtists < ActiveRecord::Migration
  def change
    remove_column :artists, :path_key
  end
end
