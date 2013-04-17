class Response < ActiveRecord::Base
  belongs_to :moment
  belongs_to :user
  attr_accessible :hearts_count
end
