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
  before_validation :strip_attributes
  before_save :assign_unique_token

  # trim whitespace from beginning and end of string attributes  
  def strip_attributes
    attribute_names().each do |name|
      if self.send(name.to_sym).respond_to?(:strip)
        self.send("#{name}=".to_sym, self.send(name).strip)
      end
    end
  end

  # set the default values for the Moment
  def default_values
    self.trash ||= false
  end

  # logic for creating a unique token for the Moment
  def assign_unique_token
    unless(self.token)
      begin
        self.token = rand(36**8).to_s(36)
      end while self.class.exists?(:token => token)
    end
  end

  def id_to_base_36
    return self.id.to_s(36)
  end

  def base_36_to_id(base_number)
    return base_number.to_i(10)
  end

end
