class CreateAppearances < ActiveRecord::Migration
  def change
    create_table :appearances do |t|
      t.integer :festival_id
      t.integer :artist_id

      t.timestamps
    end
  end
end
