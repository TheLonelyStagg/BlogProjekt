class Post < ApplicationRecord
  belongs_to :blog
  has_many :comments, dependent: :destroy
  
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  attr_accessor :tagipostu
  validates :title, presence: true
  validates :text_content, presence: true
end
