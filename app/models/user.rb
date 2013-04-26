class User < ActiveRecord::Base
  rolify
  
  attr_accessible :role_ids, :as => :admin
  attr_accessible :provider, :uid, :name, :email, :image
  
  validates_presence_of :name

  has_many :responses
  has_many :moments, :through => :responses, :class_name => "Moment", :order => 'responses.created_at DESC'
  has_many :authored_moments, :foreign_key => "author_id", :class_name => "Moment"

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth['provider']
      user.uid = auth['uid']
      if auth['info']
         user.name = auth['info']['name'] || ""
         user.email = auth['info']['email'] || ""
      end
    end
  end

  # Gets image from facebook https://developers.facebook.com/docs/reference/api/using-pictures/
  def image(type = "square")
    "https://graph.facebook.com/" + uid + "/picture?type=" + type
  end

  def image_by_dimension(width = 40, height = 40)
    "https://graph.facebook.com/" + uid + "/picture?width=" + width.to_s + "&" + "height=" + height.to_s
  end

end
