class Comment < ApplicationRecord
  acts_as_votable
  belongs_to :post
  belongs_to :user

  validates :content, presence: true
end
