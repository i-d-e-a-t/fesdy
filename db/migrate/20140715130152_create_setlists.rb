class CreateSetlists < ActiveRecord::Migration
  def change
    create_table :setlists do |t|
      t.integer :appearance_id

      t.timestamps
    end
  end
end
