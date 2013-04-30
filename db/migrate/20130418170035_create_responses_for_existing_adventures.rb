class CreateResponsesForExistingAdventures < ActiveRecord::Migration
  def up
    Adventure.all.each do |adventure|
      Response.where(:user_id => adventure.author_id, :adventure_id => adventure.id).first_or_create!
    end
  end

  def down
  end
end
