class CreatePipes < ActiveRecord::Migration
  def change
    create_table :pipes do |t|
      t.string :pipe
      t.boolean :active

      t.timestamps
    end
  end
end
