class CreateAppLayers < ActiveRecord::Migration
  def change
    create_table :app_layers do |t|
      t.string :app_layer
      t.boolean :active

      t.timestamps
    end
  end
end
