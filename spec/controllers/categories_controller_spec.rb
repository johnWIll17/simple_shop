require 'rails_helper'

describe CategoriesController do

  describe 'user access' do
    before :each do
      user = create(:user)
      session[:user_id] = user.id
    end

    #same cases here
    describe 'GET #index' do
      context 'with params[:search]' do
        it 'populates an array of categories that match the search term' do
          category1 = create(:category, category_name: 'Category 1')
          category2 = create(:category, category_name: 'New Category', active: false)

          search_test = ['new', 'active', 'deactive', 'cat']
          search_result = [ [category2], [category1, category2], [category2], [category1, category2] ]

          search_test.each_with_index do |search, index|
            get :index, search: search
            expect(assigns(:model_objects)).to match_array( search_result[index] )
          end
        end

        it 'render the :index template' do
          get :index, search: 'ca'
          expect(response).to render_template :index
        end
      end

      context 'without params[:search]' do
        it 'populates an array of all categories' do
          category1 = create(:category, category_name: 'Category 1')
          category2 = create(:category, category_name: 'New Category', active: false)

          get :index
          expect(assigns(:model_objects)).to match_array( [category1, category2] )
        end

        it 'renders the :index template' do
          get :index
          expect(response).to render_template :index
        end
      end

      context 'with params[:sort] and params[:direction]' do
        it 'populates an array as order' do
          category1 = create(:category, category_name: 'Category 1')
          category2 = create(:category, category_name: 'New Category', active: false)

          get :index, sort: 'category_name', direction: 'desc'
          expect(assigns(:model_objects)).to eq [category2, category1]
        end
      end
    end

    describe 'GET #new' do
      it 'assigns a new Category to @model_object' do
        get :new
        expect(assigns(:model_object)).to be_a_new(Category)
      end

      it 'render the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      context 'with valid edit id' do
        it 'assigns the requested category to @model_object' do
          category = create(:category)
          get :edit, id: category
          expect(assigns(:model_object)).to eq category
        end

        it 'render the :edit template' do
          category = create(:category)
          get :edit, id: category
          expect(response).to render_template :edit
        end
      end

      context 'with invalid edit id' do
        it 'redirects to 404 when accessing invalid id' do
          category = create(:category)
          category.destroy

          get :edit, id: category.id
          expect(response).to redirect_to '/404'
        end
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new category in the database' do
          expect {
            post :create, category: attributes_for(:category)
          }.to change(Category, :count).by(1)
        end

        it 'redirects to categories#index' do
          post :create, category: attributes_for(:category)
          expect(response).to redirect_to categories_path
        end
      end

      context 'with invalid attribtues' do
        it 'does not save the new category in the database' do
          expect {
            post :create, category: attributes_for(:invalid_category)
          }.to_not change(Category, :count)
        end

        it 're-render the :new template' do
          post :create, category: attributes_for(:invalid_category)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        @category = create(:category,
                           category_name: 'Category new',
                           active: true)
      end

      context 'with valid attributes' do
        it 'retrieve the requested category' do
          patch :update, id: @category, category: attributes_for(:category)
          expect(assigns(:model_object)).to eq @category
        end

        it 'updates new attributes to category' do
          patch :update, id: @category,
            category: attributes_for(:category,
                                     category_name: 'New updated category',
                                     active: 'Active')
            @category.reload
            expect(@category.category_name).to eq 'New updated category'
            expect(@category.active).to eq true
        end

        it 'redirects to the categories#index' do
          patch :update, id: @category, category: attributes_for(:category)
          expect(response).to redirect_to categories_path
        end
      end


      context 'with invalid attributes' do
        it 'does not update the category' do
          patch :update, id: @category, category: attributes_for(:category,
            category_name: 'Error-category')
          expect(@category.category_name).not_to eq 'Error-product'
        end

        it 're-render :edit template' do
          patch :update, id: @category, category: attributes_for(:invalid_category)
          expect(response).to render_template :edit
        end
      end

    end

    describe 'PUT active' do
      before :each do
        request.env["HTTP_REFERER"] = "http://localhost:3000/categories/"
      end

      context 'active a category' do
        it 'update a category to active' do
          category1 = create(:category, category_name: 'Category 1', active: false)
          category2 = create(:category, category_name: 'Category 2', active: false)

          put :status_form, button_name: 'active', selected_ids: [category1.id, category2.id]
          [category1, category2].each do |category|
            category.reload
            expect(category.active).to eq true
          end
        end
      end

      context 'deactive a category' do
        it 'update a category to deactive' do
          category1 = create(:category, category_name: 'Category 1', active: true)
          category2 = create(:category, category_name: 'Category 2', active: true)

          put :status_form, button_name: 'deactive', selected_ids: [category1.id, category2.id]
          [category1, category2].each do |category|
            category.reload
            expect(category.active).to eq false
          end
        end
      end
    end

  end
###################################
  describe 'guest access' do
    describe 'GET #index' do
      it 'requires login' do
        get :index
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'GET #edit' do
      it 'requires login' do
        category = create(:category)
        get :edit, id: category
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, id: create(:category),
          category: attributes_for(:category)
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'PUT #update' do
      it 'requires login' do
        put :update, id: create(:category),
          category: attributes_for(:category)
        expect(response).to redirect_to log_in_url
      end
    end
  end

end
