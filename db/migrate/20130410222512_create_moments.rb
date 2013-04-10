class CreateMoments < ActiveRecord::Migration
  def change
    create_table :moments do |t|
      t.string :name
      t.text :description
      t.references :author
      t.string :token
      t.boolean :trash

      t.timestamps
    end
    add_index :moments, :author_id
  end
end
