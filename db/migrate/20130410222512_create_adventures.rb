class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string :name
      t.text :description
      t.references :author
      t.string :token
      t.boolean :trash

      t.timestamps
    end
    add_index :adventures, :author_id
  end
end
