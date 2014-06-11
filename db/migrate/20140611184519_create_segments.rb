class CreateSegments < ActiveRecord::Migration
  def change
    create_table :segments do |t|
      t.string :segment
      t.boolean :active

      t.timestamps
    end
  end
end
