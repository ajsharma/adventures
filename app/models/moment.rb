class Moment < ActiveRecord::Base
  
  # keep the default scope first (if any)

  # constants come up next

  # afterwards we put attr related macros
  attr_accessible :description, :name

  # followed by association macros  
  belongs_to :author, :foreign_key => "author_id"
  
  # and validation macros
  validates :name, :presence => true

  # next we have callbacks
  after_initialize :default_values, if: 'new_record?' # set defaults on new records
  
  # set the default values for the Moment
  def default_values
    self.trash ||= false
  end

end
