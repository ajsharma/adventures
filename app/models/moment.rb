class Moment < ActiveRecord::Base
  
  # keep the default scope first (if any)

  # constants come up next

  # afterwards we put attr related macros
  attr_accessible :description, :name

  # followed by association macros  
  belongs_to :author, :foreign_key => "author_id", :class_name => "User"
  
  # and validation macros
  validates :name, :presence => true

  # next we have callbacks
  after_initialize :default_values, if: 'new_record?' # set defaults on new records
  before_save :set_unique_token
  
  # set the default values for the Moment
  def default_values
    self.trash ||= false
  end

  # logic for creating a unique token for the Moment
  def set_unique_token
    begin
      self.token = SecureRandom.hex(5) # or whatever you chose like UUID tools
    end while self.class.exists?(:token => token)
  end

end
