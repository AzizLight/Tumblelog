# == Schema Information
#
# Table name: posts
#
#  id         :integer         not null, primary key
#  title      :string(255)
#  body       :text
#  created_at :datetime
#  updated_at :datetime
#  user_id    :integer
#  draft      :integer
#

class Post < ActiveRecord::Base
  attr_accessible :title, :body, :user_id, :draft
  
  belongs_to :user
  
  validates :title, :presence => true,
                    :length => { :within => 1..255 }

  validates :body, :presence => true

  validates :user_id, :presence => true,
                      :numericality => {
                                         :only_integer => true,
                                         :greater_than_or_equal_to => 1
                                       }

  validates :draft, :presence => true
end
