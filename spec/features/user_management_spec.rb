require 'rails_helper'

feature 'User management' do
  include FeatureHelpers

  before :each do
    @user = create(:user)

    log_in_with @user.email, 'whatispassword'
    visit categories_path
  end

  feature 'Add user' do

    scenario 'Add valid user' do
      expect {
        click_link 'Users'
        click_link 'Add User'
        fill_in 'Username', with: 'usertest1234'
        fill_in 'Email', with: 'usertest1234@example.com'
        fill_in 'Password', with: 'secret1234'
        fill_in 'Password confirmation', with: 'secret1234'
        click_button 'Create User'
      }.to change(User, :count).by(1)

      expect(current_path).to eq users_path
      expect(page).to have_content 'You have created successfully!'

      within 'h1' do
        expect(page).to have_content 'Users Management'
      end

      click_link 'ID'
      expect(page).to have_content 'usertest1234'
    end


    feature 'Add invalid user' do

      scenario 'with invalid username' do
        expect {
          click_link 'Users'
          click_link 'Add User'
          fill_in 'Username', with: 'usertest error'
          fill_in 'Email', with: 'usertest1234@example.com'
          fill_in 'Password', with: 'secret1234'
          fill_in 'Password confirmation', with: 'secret1234'
          click_button 'Create User'
        }.not_to change(User, :count)

        expect(page).to have_content 'Just accept letters, numbers, _ and -'
      end

      scenario 'with invalid email' do
        expect {
          click_link 'Users'
          click_link 'Add User'
          fill_in 'Username', with: 'usertest1234'
          fill_in 'Email', with: 'usertest12 34@@@ example,com'
          fill_in 'Password', with: 'secret1234'
          fill_in 'Password confirmation', with: 'secret1234'
          click_button 'Create User'
        }.not_to change(User, :count)

        expect(page).to have_content 'has invalid format'
      end

      scenario 'with empty password' do
        expect {
          click_link 'Users'
          click_link 'Add User'
          fill_in 'Username', with: 'usertest1234'
          fill_in 'Email', with: 'usertest1234@example.com'
          fill_in 'Password', with: ''
          fill_in 'Password confirmation', with: ''
          click_button 'Create User'
        }.not_to change(User, :count)

        expect(page).to have_content "can't be blank"
      end

      scenario "with password confirmation doesn't match" do
        expect {
          click_link 'Users'
          click_link 'Add User'
          fill_in 'Username', with: 'usertest1234'
          fill_in 'Email', with: 'usertest1234@example.com'
          fill_in 'Password', with: 'passwordok'
          fill_in 'Password confirmation', with: "doesn't match passwork ha"
          click_button 'Create User'
        }.not_to change(User, :count)

        expect(page).to have_content "doesn't match Password"
      end


    end
  end



  feature 'Edit, Active, Deactive user' do
    before :each do
      click_link 'Users'
      user = create(:user)
      click_link 'ID'
      expect(page).to have_content user.username
    end

    feature 'Edit user' do
      before :each do
        within 'form .table tbody tr:first-child' do
          click_link 'Edit'
        end
      end

      scenario 'with valid information' do
        fill_in 'Username', with: 'usertest4321'
        fill_in 'Email', with: 'usertest4321@example.com'
        fill_in 'Password', with: 'passwordok'
        fill_in 'Password confirmation', with: 'passwordok'
        click_button 'Update User'

        expect(current_path).to eq users_path
        expect(page).to have_content 'You have updated successfully!'

        click_link 'ID'
        expect(page).to have_content 'usertest4321'
      end


      feature 'with invalid information' do

        scenario 'with invalid username' do
          fill_in 'Username', with: 'usertest error'
          fill_in 'Email', with: 'usertest4321@example.com'
          fill_in 'Password', with: 'passwordok'
          fill_in 'Password confirmation', with: 'passwordok'
          click_button 'Update User'

          expect(page).to have_content 'Just accept letters, numbers, _ and -'
        end

        scenario 'with invalid email' do
          fill_in 'Username', with: 'usertest1234'
          fill_in 'Email', with: 'usertest4321@e@@xample.com'
          fill_in 'Password', with: 'passwordok'
          fill_in 'Password confirmation', with: 'passwordok'
          click_button 'Update User'

          expect(page).to have_content 'has invalid format'
        end

      end
    end

  end



  feature 'Active user' do
    before :each do
      #within 'form .table tbody tr:first-child' do
        #find('input[type="checkbox"]').check
      #  check('input[type="checkbox"]')
      #end
      click_link 'Users'
      @user = create(:user)
      click_link 'ID'
      expect(page).to have_content @user.username

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

  feature 'Search user' do
    before :each do
      click_link 'Users'
      @user1 = create(:user, username: 'Username1', email: 'user1@example.com')
      @user2 = create(:user, username: 'Username2', email: 'user2@example.com')
    end

    scenario 'return match users' do
      find('#search').set('use')
      click_button 'Search'

      expect(page).to have_content @user1.username
      expect(page).to have_content @user2.username
    end

    scenario 'return just user2 when the search term just matches user2' do
      find('#search').set('2')
      click_button 'Search'

      expect(page).not_to have_content @user1.username
      expect(page).to have_content @user2.username
    end

    scenario 'return just user1 when the search term just matches user1' do
      find('#search').set('1')
      click_button 'Search'

      expect(page).to have_content @user1.username
      expect(page).not_to have_content @user2.username
    end
  end


end
