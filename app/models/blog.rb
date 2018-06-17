class Blog < ApplicationRecord
  belongs_to :user
  has_many :posts, dependent: :destroy
  
  has_many :blog_kinds, dependent: :destroy
  has_many :kinds, through: :blog_kinds

  attr_accessor :rodzajeblogu
  validates :name, presence: true
  validates :name, uniqueness: true
end
