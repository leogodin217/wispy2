class CreateFronts < ActiveRecord::Migration
  def change
    create_table :fronts do |t|
      t.string :market
      t.string :segment
      t.string :site
      t.string :app_layer
      t.string :pipe
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
