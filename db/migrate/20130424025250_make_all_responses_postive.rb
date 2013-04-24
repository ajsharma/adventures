class MakeAllResponsesPostive < ActiveRecord::Migration
  def up
    Response.all.each do |response|
      response.heart! if(response.hearts_count < 1)
    end
  end

  def down
  end
end
