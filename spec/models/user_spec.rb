require 'rails_helper'

describe User do

  #test validation methods
  it 'is valid with username, email and password' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without username' do
    user = build(:user, username: nil)
    user.valid?

    expect(user.errors[:username]).to include("can't be blank")
  end

  it 'is invalid if username has just multiple whitespaces' do
    user = build(:user, username: '   ')
    user.valid?

    expect(user.errors[:username]).to include("can't be blank")
  end

  it 'is invalid without email' do
    user = build(:user, email: nil)
    user.valid?

    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without password' do
    user = build(:user, password: nil)
    user.valid?

    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with username length less than 8' do
    user = build(:user, username: 'a'*7)
    user.valid?

    expect(user.errors[:username]).to include('is too short (minimum is 8 characters)')
  end

  it 'is invalid with username length greater than 20' do
    user = build(:user, username: 'a'*21)
    user.valid?

    expect(user.errors[:username]).to include('is too long (maximum is 20 characters)')
  end

  it 'is invalid with password length less than 8' do
    user = build(:user, password: 'a'*7)
    user.valid?

    expect(user.errors[:password]).to include('is too short (minimum is 8 characters)')
  end

  it 'is invalid with password length greater than 15' do
    user = build(:user, password: 'a'*16)
    user.valid?

    expect(user.errors[:password]).to include('is too long (maximum is 15 characters)')
  end

  it 'is invalid with INVALID username format' do
    invalid_name1 = 'user?name'
    invalid_name2 = 'user\nam+e'
    invalid_name3 = '?user,name'
    invalid_name4 = "<script>alert('hello')</script>"

    [invalid_name1, invalid_name2, invalid_name3, invalid_name4].each do |invalid_name|
      user = build(:user, username: invalid_name)
      user.valid?

      expect(user.errors[:username]).to include('Just accept letters, numbers, _ and -')
    end
  end

  it 'is invalid with a duplicate email' do
    create(:user, email: 'johnwill@example.com')
    user = build(:user, email: 'johnwill@example.com')
    user.valid?

    expect(user.errors[:email]).to include('has already been taken')
  end

  it 'is invalid with INVALID email format' do
    invalid_name1 = 'user@example,com'
    invalid_name2 = 'john@@example.com.vn'
    invalid_name3 = 'bob@example@com.vn'
    invalid_name4 = 'username@_example.com.vn'

    [invalid_name1, invalid_name2, invalid_name3, invalid_name4].each do |invalid_name|
      user = build(:user, email: invalid_name)
      user.valid?

      expect(user.errors[:email]).to include('has invalid format')
    end
  end

  it 'is invalid if password and password_confirm not match' do
    user = build(:user, password: '12345678', password_confirmation: '87654321')
    user.valid?

    expect(user.errors[:password_confirmation]).to include("doesn't match Password")
  end


  #test instance methods
  it 'returns boolean true when calling new_user? on new user' do
    user = build(:user)

    expect(user.new_user?).to eq true
  end

  it 'returns boolean false when calling new_user? on an existing user' do
    user = create(:user)

    expect(user.new_user?).to eq false
  end

  #test class methods
  it 'returns a list of results that match search' do
    search_fields = [:username, :email, :active]
    user1 = create(:user, username: 'username1',     active: true,  email: 'user@example.com',  password: '12345678')
    user2 = create(:user, username: 'john_will_17',  active: false, email: 'john@ex.com.vn',    password: '12345678')
    user3 = create(:user, username: 'big_John_1985', active: true,  email: 'big_boy@user.com',  password: '12345678')

    expect( User.search('act',      search_fields) ).to eq [user1, user2, user3]
    expect( User.search('deactive', search_fields) ).to eq [user2]
    expect( User.search('john',     search_fields) ).to eq [user2, user3]
    expect( User.search('@ex',      search_fields) ).to eq [user1, user2]
  end

end
