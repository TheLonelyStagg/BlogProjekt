class Kind < ApplicationRecord
  has_many :blog_kinds, dependent: :destroy
  has_many :blogs, through: :blog_kinds
  
end
