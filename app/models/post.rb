class Post < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :location, presence: true

  belongs_to :user

end
