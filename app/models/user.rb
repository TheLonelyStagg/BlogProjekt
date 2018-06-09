class User < ApplicationRecord
  acts_as_voter
  has_many :blogs, dependent: :destroy
  has_many :comments, dependent: :destroy
end
