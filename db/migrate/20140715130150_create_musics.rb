class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.integer :artist_id

      t.timestamps
    end
  end
end
