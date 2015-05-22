require 'rails_helper'

feature 'Product management' do
  include FeatureHelpers

  before :each do
    @user = create(:user)

    log_in_with @user.email, 'whatispassword'
    visit categories_path
  end

  feature 'Add product' do

    scenario 'Add valid product' do
      expect {
        click_link 'Products'
        click_link 'Add Product'
        fill_in 'Product name', with: 'product 1'
        fill_in 'Price', with: 1563
        click_button 'Create Product'
      }.to change(Product, :count).by(1)

      expect(current_path).to eq products_path
      expect(page).to have_content 'You have created successfully!'

      within 'h1' do
        expect(page).to have_content 'Products Management'
      end

      click_link 'ID'
      expect(page).to have_content 'product 1'
    end


    feature 'Add invalid product' do

      scenario 'with invalid product name' do
        expect {
          click_link 'Products'
          click_link 'Add Product'
          fill_in 'Product name', with: 'product-error'
          fill_in 'Price', with: 4564
          click_button 'Create Product'
        }.not_to change(Product, :count)

        expect(page).to have_content 'Just accept letters, numbers and spaces'
      end

      feature 'with invalid price' do
        scenario 'price less than 0' do
          expect {
            click_link 'Products'
            click_link 'Add Product'
            fill_in 'Product name', with: 'product 1'
            fill_in 'Price', with: -155
            click_button 'Create Product'
          }.not_to change(Product, :count)

          expect(page).to have_content 'must be greater than or equal to 0'
        end

        scenario 'price is not integer' do
          expect {
            click_link 'Products'
            click_link 'Add Product'
            fill_in 'Product name', with: 'product 1'
            fill_in 'Price', with: 56.45
            click_button 'Create Product'
          }.not_to change(Product, :count)

          expect(page).to have_content 'must be an integer'
        end
      end

    end
  end



  feature 'Edit, Active, Deactive product' do
    before :each do
      click_link 'Products'
      product = create(:product)
      click_link 'ID'
      expect(page).to have_content product.product_name
    end

    feature 'Edit product' do
      before :each do
        within 'form .table tbody tr:first-child' do
          click_link 'Edit'
        end
      end

      scenario 'with valid information' do
        fill_in 'Product name', with: 'Product 1'
        fill_in 'Price', with: 546

        click_button 'Update Product'

        expect(current_path).to eq products_path
        expect(page).to have_content 'You have updated successfully!'

        click_link 'ID'
        expect(page).to have_content 'Product 1'
      end


      feature 'with invalid information' do

        scenario 'with invalid product name' do
          fill_in 'Product name', with: 'product-error'
          fill_in 'Price', with: 1645

          click_button 'Update Product'

          expect(page).to have_content 'Just accept letters, numbers and spaces'
        end

        feature 'with invalid price' do
          scenario 'price less than 0' do
            fill_in 'Product name', with: 'product ok'
            fill_in 'Price', with: -456

            click_button 'Update Product'

            expect(page).to have_content 'must be greater than or equal to 0'
          end
          scenario 'price is not integer' do
            fill_in 'Product name', with: 'product ok'
            fill_in 'Price', with: 45.65

            click_button 'Update Product'

            expect(page).to have_content 'must be an integer'
          end
        end

      end
    end

  end



  feature 'Active product' do
    before :each do
      click_link 'Products'
      @product = create(:product)
      click_link 'ID'
      expect(page).to have_content @product.product_name

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

  feature 'Search product' do
    before :each do
      click_link 'Products'
      @product1 = create(:product, product_name: 'Product 1', price: 4564)
      @product2 = create(:product, product_name: 'Product 2', price: 5893)
    end

    scenario 'return match products' do
      find('#search').set('pro')
      click_button 'Search'

      expect(page).to have_content @product1.product_name
      expect(page).to have_content @product2.product_name
    end

    scenario 'return just product2 when the search term just matches product2' do
      find('#search').set('2')
      click_button 'Search'

      expect(page).not_to have_content @product1.product_name
      expect(page).to have_content @product2.product_name
    end

    scenario 'return just user1 when the search term just matches user1' do
      find('#search').set('1')
      click_button 'Search'

      expect(page).to have_content @product1.product_name
      expect(page).not_to have_content @product2.product_name
    end
  end


end

