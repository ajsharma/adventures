class AddConstraintsToMoment < ActiveRecord::Migration
  def change

    # stupid fix, cuz there's only two users 
    Moment.all.each do |moment|
      moment.author_id = 1
      moment.save!
    end

    change_column(:moments, :author_id, :integer, :null => false)
    change_column(:responses, :moment_id, :integer, :null => false)
    change_column(:responses, :user_id, :integer, :null => false)
  end
end
