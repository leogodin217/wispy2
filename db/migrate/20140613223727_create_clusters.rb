class CreateClusters < ActiveRecord::Migration
  def change
    create_table :clusters do |t|
      t.string :name
      t.integer :front_id
      t.string :status
      t.text :notes

      t.timestamps
    end
  end
end
