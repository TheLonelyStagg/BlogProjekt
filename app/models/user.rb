class User < ApplicationRecord
  acts_as_voter
  has_many :blogs, dependent: :destroy
  has_many :comments, dependent: :destroy

  attr_accessor :pass_confirm
  attr_accessor :old_pass
  attr_accessor :new_pass

  validates :username, :name, :password, :email, :surname, :phoneNumber, presence: true
  validates :email, uniqueness: true

end
