require 'rails_helper'
require 'support/feature_helpers'

###################################################
# Log in with valid and invalid info
###################################################
feature 'Visitor sign in' do
  include FeatureHelpers

  scenario 'with valid email and password' do
    user = create(:user)
    log_in_with user.email, 'whatispassword'
    expect(page).to have_content "Welcome back #{user.username}"
  end

  scenario 'with invalid email and password' do
    user = create(:user)
    log_in_with user.email, 'thisiserrorpassword'
    expect(page).to have_content 'You have inputed wrong info. Please check out!'
  end

  scenario 'with blank email' do
    log_in_with '', 'whatisthepassword'
    expect(page).to have_content 'You have inputed wrong info. Please check out!'
  end

  scenario 'with blank password' do
    user = create(:user)
    log_in_with user.email, ''
    expect(page).to have_content 'You have inputed wrong info. Please check out!'
  end

end



###################################################
# Accessing page when haven't logged in
###################################################
feature "Access page when haven't logged in" do

  feature 'Access to management pages' do
    scenario 'categories management' do
      visit categories_path
      expect(page).to have_content 'You have to authenticate to access that page'
    end
    scenario 'products management' do
      visit products_path
      expect(page).to have_content 'You have to authenticate to access that page'
    end
    scenario 'users management' do
      visit users_path
      expect(page).to have_content 'You have to authenticate to access that page'
    end
  end

  feature 'Access to edit pages' do
    scenario 'edit category' do
      category = create(:category)
      visit edit_category_path(category)
      expect(page).to have_content 'You have to authenticate to access that page'
    end
    scenario 'edit product' do
      product = create(:product)
      visit edit_product_path(product)
      expect(page).to have_content 'You have to authenticate to access that page'
    end
    scenario 'edit user' do
      user = create(:user)
      visit edit_user_path(user)
      expect(page).to have_content 'You have to authenticate to access that page'
    end
  end

end






