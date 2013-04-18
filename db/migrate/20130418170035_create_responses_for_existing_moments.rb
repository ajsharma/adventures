class CreateResponsesForExistingMoments < ActiveRecord::Migration
  def up
    Moment.all.each do |moment|
      Response.where(:user_id => moment.author_id, :moment_id => moment.id).first_or_create!
    end
  end

  def down
  end
end
