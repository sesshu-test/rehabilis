class CreateRehabilitations < ActiveRecord::Migration[6.1]
  def change
    create_table :rehabilitations do |t|
      t.string :name
      t.integer :time
      t.integer :count
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
