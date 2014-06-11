class CreateStatuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :status
      t.boolean :active

      t.timestamps
    end
  end
end
