class CreateFestivals < ActiveRecord::Migration
  def change
    create_table :festivals do |t|

      t.timestamps
    end
  end
end
