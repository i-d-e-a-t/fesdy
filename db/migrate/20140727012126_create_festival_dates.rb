class CreateFestivalDates < ActiveRecord::Migration
  def change
    create_table :festival_dates do |t|
      t.datetime :date
      t.string :place

      t.timestamps
    end
  end
end
