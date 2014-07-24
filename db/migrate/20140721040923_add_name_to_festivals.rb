class AddNameToFestivals < ActiveRecord::Migration
  def change
    add_column :festivals, :name, :string
  end
end
