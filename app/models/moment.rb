class Moment < ActiveRecord::Base
  belongs_to :author
  attr_accessible :description, :name, :token, :trash
end
