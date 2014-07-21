class AddOfficialSiteToFestivals < ActiveRecord::Migration
  def change
    add_column :festivals, :official_site, :string
  end
end
