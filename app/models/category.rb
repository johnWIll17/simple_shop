class Category < ActiveRecord::Base
  include Searchable

  has_many :products

  validates :category_name, presence: true,
                            length: {minimum: 5, maximum: 40},
                            format: { with: VALID_NAME, message: 'Just accept letters, numbers and spaces' }

  def to_s
    category_name
  end

end
