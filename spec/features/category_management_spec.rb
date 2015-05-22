require 'rails_helper'

feature 'Categories management' do
  include FeatureHelpers

  before :each do
    @user = create(:user)

    log_in_with @user.email, 'whatispassword'
    visit categories_path
  end

  feature 'Add category' do

    scenario 'Add valid category' do
      expect {
        click_link 'Add Category'
        fill_in 'Category name', with: 'category 1'
        click_button 'Create Category'
      }.to change(Category, :count).by(1)

      expect(current_path).to eq categories_path
      expect(page).to have_content 'You have created successfully!'

      within 'h1' do
        expect(page).to have_content 'Categories Management'
      end

      click_link 'ID'
      expect(page).to have_content 'category 1'
    end


    feature 'Add invalid category' do

      scenario 'with invalid category name' do
        expect {
          click_link 'Add Category'
          fill_in 'Category name', with: 'category-error'
          click_button 'Create Category'
        }.not_to change(Category, :count)

        expect(page).to have_content 'Just accept letters, numbers and spaces'
      end

    end
  end



  feature 'Edit, Active, Deactive category' do
    before :each do
      click_link 'Categories'
      category = create(:category)
      click_link 'ID'
      expect(page).to have_content category.category_name
    end

    feature 'Edit category' do
      before :each do
        within 'form .table tbody tr:first-child' do
          click_link 'Edit'
        end
      end

      scenario 'with valid information' do
        fill_in 'Category name', with: 'New category name'
        click_button 'Update Category'

        expect(current_path).to eq categories_path
        expect(page).to have_content 'You have updated successfully!'

        click_link 'ID'
        expect(page).to have_content 'New category name'
      end


      scenario 'with invalid category name' do
        fill_in 'Category name', with: 'category-name-error'
        click_button 'Update Category'

        expect(page).to have_content 'Just accept letters, numbers and spaces'
      end
    end

  end



  feature 'Active category' do
    before :each do
      click_link 'Categories'
      @category = create(:category)
      click_link 'ID'
      expect(page).to have_content @category.category_name

      within 'form .table tbody tr:first-child' do
        find('input').set(true)
      end
    end

    scenario 'Active successfully' do
      click_button 'Active'
      expect(page).to have_content 'Successfully!'
    end

  #  #scenario 'Deactive su'

  end
  #feature 'Deactive user'

  feature 'Search category' do
    before :each do
      click_link 'Categories'
      @category1 = create(:category, category_name: 'Category 1')
      @category2 = create(:category, category_name: 'Category 2')
    end

    scenario 'return matched categories' do
      find('#search').set('cat')
      click_button 'Search'

      expect(page).to have_content @category1.category_name
      expect(page).to have_content @category2.category_name
    end

    scenario 'return just category2 when the search term just matches category2' do
      find('#search').set('2')
      click_button 'Search'

      expect(page).not_to have_content @category1.category_name
      expect(page).to have_content @category2.category_name
    end

    scenario 'return just category1 when the search term just matches category1' do
      find('#search').set('1')
      click_button 'Search'

      expect(page).to have_content @category1.category_name
      expect(page).not_to have_content @category2.category_name
    end
  end


end

