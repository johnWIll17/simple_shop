require 'rails_helper'

###################################################
# Log in with valid and invalid info
###################################################
feature 'Visitor sign in' do
  include FeatureHelpers

  scenario 'with valid email and password' do
    user = create(:user)
    log_in_with user.email, 'whatispassword'
    expect(page).to have_content "Welcome back!"
  end

  scenario 'with invalid email and password' do
    user = create(:user)
    log_in_with user.email, 'thisiserrorpassword'
    expect(page).to have_content 'Email or password is invalid. Please check out!'
  end

  scenario 'with blank email' do
    log_in_with '', 'whatisthepassword'
    expect(page).to have_content 'Email or password is invalid. Please check out!'
  end

  scenario 'with blank password' do
    user = create(:user)
    log_in_with user.email, ''
    expect(page).to have_content 'Email or password is invalid. Please check out!'
  end

end



###################################################
# Log out
###################################################
feature 'Logout when accessing successfully' do
  before :each do
    user = create(:user)
    log_in_with user.email, 'whatispassword'
  end

  describe "logout when we're at index pages" do
    scenario "at categories page" do
      visit categories_path
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end

    scenario "at products page" do
      visit products_path
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end

    scenario "at users page" do
      visit users_path
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end
  end

  describe "logout when we're at edit pages" do
    scenario "at edit category page" do
      category = create(:category)
      visit edit_category_path(category)
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end

    scenario "at edit product page" do
      product = create(:product)
      visit edit_product_path(product)
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end

    scenario "at edit user page" do
      user = create(:user)
      visit edit_user_path(user)
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end
  end

  describe "logout when we're at any page" do
    scenario 'at page that have search category term, sort table' do
      visit "/categories?direction=asc&sort=category_name&search=ca"
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end

    scenario 'at page that have search product term, sort table' do
      visit "/products?direction=asc&sort=product_name&search=pr"
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end

    scenario 'at page that have search user term, sort table' do
      visit "/users?direction=asc&sort=username&search=us"
      click_link 'Logout'
      expect(current_path).to eq log_in_path
      expect(page).to have_content 'Sign out!'
    end
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






