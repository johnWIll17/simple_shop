require 'rails_helper'

describe UsersController do

  describe 'adminstration' do
    before :each do
      @user = create(:admin, username: 'adminuser', email: 'admin@user.com.vn')
      session[:user_id] = @user.id
    end

    #same cases here
    describe 'GET #index' do
      context 'with params[:search]' do
        it 'populates an array of users that match the search term' do
          user1 = create(:user, username: 'username-1'  , email: 'user1@example.com')
          user2 = create(:user, username: 'New_user_created', email: 'newuser@gmail.com', active: false)

          search_test = ['new', 'active', 'deactive', 'us', '@', 'user1']
          search_result = [ [user2], [user1, user2, @user], [user2], [user1, user2, @user], [user1, user2, @user], [user1] ]

          search_test.each_with_index do |search, index|
            get :index, search: search
            expect(assigns(:model_objects)).to match_array( search_result[index] )
          end
        end

        it 'render the :index template' do
          get :index, search: 'us'
          expect(response).to render_template :index
        end
      end

      context 'without params[:search]' do
        it 'populates an array of all users' do
          user1 = create(:user, username: 'username-1')
          user2 = create(:user, username: 'New_user_created', active: false)

          get :index
          expect(assigns(:model_objects)).to match_array( [user1, user2, @user] )
        end

        it 'renders the :index template' do
          get :index
          expect(response).to render_template :index
        end
      end

      context 'with params[:sort] and params[:direction]' do
        it 'populates an array as order' do
          user1 = create(:user, username: 'username-1')
          user2 = create(:user, username: 'New_user_created', active: false)
          get :index, sort: 'username', direction: 'desc'
          expect(assigns(:model_objects)).to eq [user1, user2, @user]
        end
      end
    end

    describe 'GET #new' do
      it 'assigns a new user to @model_object' do
        get :new
        expect(assigns(:model_object)).to be_a_new(User)
      end

      it 'render the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      context 'with valid id' do
        it 'assigns the requested user to @model_object' do
          user = create(:user)
          get :edit, id: user
          expect(assigns(:model_object)).to eq user
        end

        it 'render the :edit template' do
          user = create(:user)
          get :edit, id: user
          expect(response).to render_template :edit
        end
      end

      context 'with invalid id' do
        it 'redirect to 404' do
          get :edit, id: 1000000
          expect(response).to redirect_to '/404'
        end
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new user in the database' do
          expect {
            post :create, user: attributes_for(:user)
          }.to change(User, :count).by(1)
        end

        it 'redirects to users#index' do
          post :create, user: attributes_for(:user)
          expect(response).to redirect_to users_path
        end
      end

      context 'with invalid attribtues' do
        it 'does not save the new user in the database' do
          expect {
            post :create, user: attributes_for(:invalid_user)
          }.to_not change(User, :count)
        end

        it 're-render the :new template' do
          post :create, user: attributes_for(:invalid_user)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        @user = create(:user,
          username: 'Username-20',
          active: true)
      end

      context 'with valid attributes' do
        it 'retrieve the requested user' do
          patch :update, id: @user, user: attributes_for(:user)
          expect(assigns(:model_object)).to eq @user
        end

        it 'updates new attributes to user' do
          patch :update, id: @user,
            user: attributes_for(:user,
              username: 'Newuser-updated',
              active: 'Active')
            @user.reload
            expect(@user.username).to eq 'Newuser-updated'
            expect(@user.active).to eq true
        end

        it 'redirects to the users#index' do
          patch :update, id: @user, user: attributes_for(:user)
          expect(response).to redirect_to users_path
        end
      end


      context 'with invalid attributes' do
        it 'does not update the user' do
          patch :update, id: @user, user: attributes_for(:user,
            username: 'Error user')
          expect(@user.username).not_to eq 'Error user'
        end

        it 're-render :edit template' do
          patch :update, id: @user, user: attributes_for(:invalid_user)
          expect(response).to render_template :edit
        end
      end

    end

    describe 'PUT active' do
      before :each do
        request.env["HTTP_REFERER"] = "http://localhost:3000/users/"
      end

      context 'active a user' do
        it 'update a user to active' do
          user1 = create(:user, username: 'Username1', active: false)
          user2 = create(:user, username: 'Username2', active: false)

          put :status_form, button_name: 'active', selected_ids: [user1.id, user2.id]
          [user1, user2].each do |user|
            user.reload
            expect(user.active).to eq true
          end
        end
      end

      context 'deactive a user' do
        it 'update a user to deactive' do
          user1 = create(:user, username: 'Username1', active: true)
          user2 = create(:user, username: 'Username2', active: true)

          put :status_form, button_name: 'deactive', selected_ids: [user1.id, user2.id]
          [user1, user2].each do |user|
            user.reload
            expect(user.active).to eq false
          end
        end
      end
    end
    ###############
  end
###################################

  describe 'user access' do
    before :each do
      @user = create(:user, username: 'normaluser', email: 'normal@example.com')
      session[:user_id] = @user.id
    end

    #same cases here
    describe 'GET #index' do
      it 'redirects to user show page' do
        get :index
        expect(response).to redirect_to user_path(@user)
      end
    end

    describe 'GET #edit' do
      it 'retrieves the user info' do
        get :edit, id: @user
        expect(assigns(:model_object)).to eq @user
      end

      it 'render edit template' do
        get :edit, id: @user
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      it 'redirects to user show page' do
        user = create(:user)
        post :create, id: user,
          user: attributes_for(:user)
        expect(response).to redirect_to user_path(@user)
      end
    end

    describe 'PUT #update' do
      context 'valid update' do
        it 'retrieve the user info' do
          put :update, id: @user,
            user: attributes_for(:user)
          expect(assigns(:model_object)).to eq @user
        end

        it 'update valid user' do
          put :update, id: @user,
            user: attributes_for(:user,
              username: 'New_updated_user',
              email: 'newemail@example.com')
          @user.reload
          expect(@user.username).to eq 'New_updated_user'
          expect(@user.email).to eq 'newemail@example.com'
        end

        it 'render user show page' do
          put :update, id: @user, user: attributes_for(:user)
          expect(response).to redirect_to user_path(@user)
        end

      end

      context 'invalid update' do
        it 'not update user' do
          put :update, id: @user, user: attributes_for(:user,
                                                      username: 'New_name_user')
          expect(@user.username).not_to eq 'New_name_user'
        end

        it 're-render edit' do
          put :update, id: @user, user: attributes_for(:invalid_user)
          expect(response).to render_template :edit
        end
      end
    end
    ###############
  end


######################################
  describe 'guest access' do
    describe 'GET #index' do
      it 'requires login' do
        get :index
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'GET #edit' do
      it 'requires login' do
        user = create(:user)
        get :edit, id: user
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, id: create(:user),
          user: attributes_for(:user)
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'PUT #update' do
      it 'requires login' do
        put :update, id: create(:user),
          user: attributes_for(:user)
        expect(response).to redirect_to log_in_url
      end
    end


  end

end
