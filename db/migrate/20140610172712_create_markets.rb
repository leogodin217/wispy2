class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :market
      t.boolean :active

      t.timestamps
    end
  end
end
