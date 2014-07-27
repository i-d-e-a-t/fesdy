class RenameColumnFestivalIdToFestivalDateIdOnAppearance < ActiveRecord::Migration
  def up
    add_column :appearances, :festival_date_id, :integer
    remove_column :appearances, :festival_id
  end

  def down
    add_column :appearances, :festival_id, :integer
    remove_column :appearances, :festival_date_id
  end
end
