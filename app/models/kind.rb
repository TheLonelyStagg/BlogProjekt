class Kind < ApplicationRecord
  has_many :blog_kinds
  has_many :blogs, through: :blog_kinds
  
end
