require 'rails_helper'

describe ProductsController do

  describe 'adminstration' do
    before :each do
      user = create(:admin)
      session[:user_id] = user.id
    end

    #same cases here
    describe 'GET #index' do
      context 'with params[:search]' do
        it 'populates an array of products that match the search term' do
          product1 = create(:product, product_name: 'Product 10')
          product2 = create(:product, product_name: 'New Product', active: false)

          search_test = ['new', 'active', 'deactive', 'ro']
          search_result = [ [product2], [product1, product2], [product2], [product1, product2] ]

          search_test.each_with_index do |search, index|
            get :index, search: search
            expect(assigns(:model_objects)).to match_array( search_result[index] )
          end
        end

        it 'render the :index template' do
          get :index, search: 'pr'
          expect(response).to render_template :index
        end
      end

      context 'without params[:search]' do
        it 'populates an array of all products' do
          product1 = create(:product, product_name: 'Product 1')
          product2 = create(:product, product_name: 'New Product', active: false)

          get :index
          expect(assigns(:model_objects)).to match_array( [product1, product2] )
        end

        it 'renders the :index template' do
          get :index
          expect(response).to render_template :index
        end
      end

      context 'with params[:sort] and params[:direction]' do
        it 'populates an array as order' do
          product1 = create(:product, product_name: 'Product 1')
          product2 = create(:product, product_name: 'New Product', active: false)
          get :index, sort: 'product_name', direction: 'desc'
          expect(assigns(:model_objects)).to eq [product1, product2]
        end
      end
    end

    describe 'GET #new' do
      it 'assigns a new Product to @model_object' do
        get :new
        expect(assigns(:model_object)).to be_a_new(Product)
      end

      it 'render the :new template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      context 'with valid id' do
        it 'assigns the requested product to @model_object' do
          product = create(:product)
          get :edit, id: product
          expect(assigns(:model_object)).to eq product
        end

        it 'render the :edit template' do
          product = create(:product)
          get :edit, id: product
          expect(response).to render_template :edit
        end
      end

      context 'with invalid id' do
        it 'redirect to 404 when accessing invalid id' do
          #get :edit, id: 100000
          product = create(:product)
          product.destroy
          get :edit, id: product.id
          expect(response).to redirect_to '/404'
        end
      end
    end

    describe 'POST #create' do
      context 'with valid attributes' do
        it 'saves the new product in the database' do
          expect {
            post :create, product: attributes_for(:product)
          }.to change(Product, :count).by(1)
        end

        it 'redirects to products#index' do
          post :create, product: attributes_for(:product)
          expect(response).to redirect_to products_path
        end
      end

      context 'with invalid attribtues' do
        it 'does not save the new product in the database' do
          expect {
            post :create, product: attributes_for(:invalid_product)
          }.to_not change(Product, :count)
        end

        it 're-render the :new template' do
          post :create, product: attributes_for(:invalid_product)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        @product = create(:product,
                           product_name: 'Product new',
                           active: true)
      end

      context 'with valid attributes' do
        it 'retrieve the requested product' do
          patch :update, id: @product, product: attributes_for(:product)
          expect(assigns(:model_object)).to eq @product
        end

        it 'updates new attributes to products' do
          patch :update, id: @product,
            product: attributes_for(:product,
                                     product_name: 'New updated product',
                                     active: 'Active')
            @product.reload
            expect(@product.product_name).to eq 'New updated product'
            expect(@product.active).to eq true
        end

        it 'redirects to the products#index' do
          patch :update, id: @product, product: attributes_for(:product)
          expect(response).to redirect_to products_path
        end
      end

        context 'with invalid attributes' do
          it 'does not update the products' do
            patch :update, id: @product, product: attributes_for(:product,
              product_name: 'Error-product')
            expect(@product.product_name).not_to eq 'Error-product'
          end

          it 're-render :edit template' do
            patch :update, id: @product, product: attributes_for(:invalid_product)
            expect(response).to render_template :edit
          end
        end
    end

    describe 'PUT active' do
      before :each do
        request.env["HTTP_REFERER"] = "http://localhost:3000/products/"
      end

      context 'active a product' do
        it 'update a product to active' do
          product1 = create(:product, product_name: 'Product 1', active: false)
          product2 = create(:product, product_name: 'Product 2', active: false)

          put :status_form, button_name: 'active', selected_ids: [product1.id, product2.id]
          [product1, product2].each do |product|
            product.reload
            expect(product.active).to eq true
          end
        end
      end

      context 'deactive a products' do
        it 'update a product to deactive' do
          product1 = create(:product, product_name: 'Product 1', active: true)
          product2 = create(:product, product_name: 'Product 2', active: true)

          put :status_form, button_name: 'deactive', selected_ids: [product1.id, product2.id]
          [product1, product2].each do |product|
            product.reload
            expect(product.active).to eq false
          end
        end
      end
    end
    ###############
  end
###################################

  describe 'user access' do
    before :each do
      @user = create(:user)
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
      it 'redirects to user show page' do
        product = create(:product)
        get :edit, id: product
        expect(response).to redirect_to user_path(@user)
      end
    end

    describe 'POST #create' do
      it 'redirects to user show page' do
        product = create(:product)
        post :create, id: product,
          product: attributes_for(:product)
        expect(response).to redirect_to user_path(@user)
      end
    end

    describe 'PUT #update' do
      it 'redirects to user show page' do
        product = create(:product)
        put :update, id: product,
          product: attributes_for(:product)
        expect(response).to redirect_to user_path(@user)
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
        product = create(:product)
        get :edit, id: product
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'POST #create' do
      it 'requires login' do
        post :create, id: create(:product),
          product: attributes_for(:product)
        expect(response).to redirect_to log_in_url
      end
    end

    describe 'PUT #update' do
      it 'requires login' do
        put :update, id: create(:product),
          product: attributes_for(:product)
        expect(response).to redirect_to log_in_url
      end
    end


  end

end

