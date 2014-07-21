class AddEndDateToFestivals < ActiveRecord::Migration
  def change
    add_column :festivals, :end_date, :datetime
  end
end
