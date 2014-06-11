class CreateSites < ActiveRecord::Migration
  def change
    create_table :sites do |t|
      t.string :site
      t.boolean :active

      t.timestamps
    end
  end
end
