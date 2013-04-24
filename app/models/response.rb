class Response < ActiveRecord::Base

  # keep the default scope first (if any)

  # constants come up next

  # afterwards we put attr related macros
  attr_accessible :hearts_count

  # followed by association macros  
  belongs_to :moment
  belongs_to :user
  
  # and validation macros

  # next we have callbacks
  after_initialize :default_values, if: 'new_record?' # set defaults on new records

  def heart! 
    self.increment!(:hearts_count)
  end

  private 
    # set the default values for the Moment
    def default_values
      self.hearts_count = 1
    end

end