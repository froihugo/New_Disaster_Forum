class Post < ApplicationRecord

  default_scope { where(delete_at: nil) }
  validates :title, presence: true
  validates :content, presence: true
  validates :location, presence: true

  belongs_to :user
  has_many :comments
  has_many :post_category_ships
  has_many :categories, through: :post_category_ships

  def destroy
    update(delete_at: Time.now)
  end

  after_validation :generate_short_string

  private

  def generate_short_string
    loop do
      @string_unique = sprintf "%07d", rand(0..9999999)
      break unless Post.exists?(unique_string: @string_unique)
    end
    self.unique_string = @string_unique
  end
end

