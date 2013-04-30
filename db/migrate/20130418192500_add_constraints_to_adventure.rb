class AddConstraintsToAdventure < ActiveRecord::Migration
  def change

    # stupid fix, cuz there's only two users 
    Adventure.all.each do |adventure|
      adventure.author_id = 1
      adventure.save!
    end

    change_column(:adventures, :author_id, :integer, :null => false)
    change_column(:responses, :adventure_id, :integer, :null => false)
    change_column(:responses, :user_id, :integer, :null => false)
  end
end
