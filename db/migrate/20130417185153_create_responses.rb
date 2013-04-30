class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :adventure
      t.references :user
      t.integer :hearts_count, :default => 0

      t.timestamps
    end
    add_index :responses, :adventure_id
    add_index :responses, :user_id
  end
end
