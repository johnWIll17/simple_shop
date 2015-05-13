class Product < ActiveRecord::Base

  include Searchable

  has_many :pictures
  belongs_to :category

  validates :product_name, presence: true,
                           length: { minimum: 5, maximum: 40 },
                           format: { with: VALID_NAME, message: 'Just accept letters, numbers and spaces' }
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
