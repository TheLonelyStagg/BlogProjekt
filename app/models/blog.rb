class Blog < ApplicationRecord
  belongs_to :user
  has_many :posts
  
  has_many :blog_kinds
  has_many :kinds, through: :blog_kinds

  attr_accessor :rodzajeblogu
end
