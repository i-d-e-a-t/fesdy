class CreatePrograms < ActiveRecord::Migration
  def change
    create_table :programs do |t|
      t.integer :setlist_id
      t.integer :music_id

      t.timestamps
    end
  end
end