class Post < ApplicationRecord
  belongs_to :blog
  has_many :comments
  
  has_many :post_tags
  has_many :tags, through: :post_tags

  attr_accessor :tagipostu
end
