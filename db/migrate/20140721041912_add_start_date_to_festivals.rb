class AddStartDateToFestivals < ActiveRecord::Migration
  def change
    add_column :festivals, :start_date, :datetime
  end
end
