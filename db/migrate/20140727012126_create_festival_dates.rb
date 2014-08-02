class CreateFestivalDates < ActiveRecord::Migration
  def change
    create_table :festival_dates do |t|
      t.integer :festival_id
      t.datetime :date
      t.string :place

      t.timestamps
    end
  end
end
