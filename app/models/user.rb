class User < ActiveRecord::Base
  include Searchable

  mount_uploader :avatar, ImageUploader

  VALID_USERNAME = /\A[a-zA-Z\d\-\_]*\Z/i
  authenticates_with_sorcery!

  validates :password, presence: true,
                       length: { minimum: 8, maximum: 15 },
                       confirmation: true,
                       if: :new_user?
  validates :email, presence: true,
                    uniqueness: true,
                    email_format: { message: 'has invalid format' }
  validates :username, presence: true,
                       length: { minimum: 8, maximum: 20 },
                       format: { with: VALID_USERNAME, message: 'Just accept letters, numbers, _ and -' }

  def new_user?
    new_record?
  end
end
