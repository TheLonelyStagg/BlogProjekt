class Post < ApplicationRecord
  belongs_to :blog
  has_many :comments, dependent: :destroy
  
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  attr_accessor :tagipostu

  validates :title, presence: true
  validates :text_content, presence: true

  has_attached_file :image, styles: { large: "1400x1400>", medium: "800x800>", small: "500x500", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

end
