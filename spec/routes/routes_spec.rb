require 'rails_helper'


describe 'Testing route', type: :routing do

  describe 'root routing' do
    it 'root route to log_in page' do
      expect(get: '/').to route_to(
        controller: 'sessions',
        action: 'new'
      )
    end
  end

  #============================================
  describe 'Category routing' do
    it 'GET#index' do
      expect(get: '/categories').to route_to(
        controller: 'categories',
        action: 'index'
      )
    end

    it 'GET#new' do
      expect(get: '/categories/new').to route_to(
        controller: 'categories',
        action: 'new'
      )
    end

    it 'POST#create' do
      expect(post: '/categories').to route_to(
        controller: 'categories',
        action: 'create'
      )
    end

    it 'GET#edit' do
      category = create(:category)
      expect(get: "/categories/#{category.id}/edit").to route_to(
        controller: 'categories',
        action: 'edit',
        id: category.id.to_s
      )
    end

    it 'PUT#update' do
      category = create(:category)
      expect(put: "/categories/#{category.id}").to route_to(
        controller: 'categories',
        action: 'update',
        id: category.id.to_s
      )
    end

    it 'PUT#status_form' do
      category = create(:category)
      expect(put: 'categories/status').to route_to(
        controller: 'categories',
        action: 'status_form'
      )
    end
  end

  #============================================
  describe 'Product routing' do
    it 'GET#index' do
      expect(get: '/products').to route_to(
        controller: 'products',
        action: 'index'
      )
    end

    it 'GET#new' do
      expect(get: '/products/new').to route_to(
        controller: 'products',
        action: 'new'
      )
    end

    it 'POST#create' do
      expect(post: '/products').to route_to(
        controller: 'products',
        action: 'create'
      )
    end

    it 'GET#edit' do
      product = create(:product)
      expect(get: "/products/#{product.id}/edit").to route_to(
        controller: 'products',
        action: 'edit',
        id: product.id.to_s
      )
    end

    it 'PUT#update' do
      product = create(:product)
      expect(put: "/products/#{product.id}").to route_to(
        controller: 'products',
        action: 'update',
        id: product.id.to_s
      )
    end

    it 'PUT#status_form' do
      product = create(:product)
      expect(put: 'products/status').to route_to(
        controller: 'products',
        action: 'status_form'
      )
    end

  end

  #============================================
  describe 'User routing' do
    it 'GET#index' do
      expect(get: '/users').to route_to(
        controller: 'users',
        action: 'index'
      )
    end

    it 'GET#new' do
      expect(get: '/users/new').to route_to(
        controller: 'users',
        action: 'new'
      )
    end

    it 'POST#create' do
      expect(post: '/users').to route_to(
        controller: 'users',
        action: 'create'
      )
    end

    it 'GET#edit' do
      user = create(:user)
      expect(get: "/users/#{user.id}/edit").to route_to(
        controller: 'users',
        action: 'edit',
        id: user.id.to_s
      )
    end

    it 'PUT#update' do
      user = create(:user)
      expect(put: "/users/#{user.id}").to route_to(
        controller: 'users',
        action: 'update',
        id: user.id.to_s
      )
    end

    it 'PUT#status_form' do
      user = create(:user)
      expect(put: 'users/status').to route_to(
        controller: 'users',
        action: 'status_form'
      )
    end

    it 'DELETE#delete_avatar' do
      user = create(:user)
      expect(delete: "users/#{user.id}/delete/avatar").to route_to(
        controller: 'users',
        action: 'delete_avatar',
        id: user.id.to_s
      )
    end
  end

  #============================================
  describe 'Sessions routing' do
    it 'GET#new' do
      expect(get: '/sessions/new').to route_to(
        controller: 'sessions',
        action: 'new'
      )
    end

    it 'POST#create' do
      expect(post: '/sessions').to route_to(
        controller: 'sessions',
        action: 'create'
      )
    end

    it 'DELETE#destroy' do
      user = create(:user)
      expect(delete: "sessions/#{user.id}").to route_to(
        controller: 'sessions',
        action: 'destroy',
        id: user.id.to_s
      )
    end
  end

  #============================================
  describe 'login and logout routing' do
    it 'login route' do
      expect(get: '/log_in').to route_to(
        controller: 'sessions',
        action: 'new'
      )
    end
    it 'logout route' do
      expect(delete: '/log_out').to route_to(
        controller: 'sessions',
        action: 'destroy'
      )
    end
  end

  #============================================
  describe 'Named routes' do

    #============================================
    describe 'Category routing' do
      it 'GET#index' do
        expect(get: categories_path).to route_to(
          controller: 'categories',
          action: 'index'
        )
      end

      it 'GET#new' do
        expect(get: new_category_path).to route_to(
          controller: 'categories',
          action: 'new'
        )
      end

      it 'POST#create' do
        expect(post: categories_path).to route_to(
          controller: 'categories',
          action: 'create'
        )
      end

      it 'GET#edit' do
        category = create(:category)
        expect(get: edit_category_path(category) ).to route_to(
          controller: 'categories',
          action: 'edit',
          id: category.id.to_s
        )
      end

      it 'PUT#update' do
        category = create(:category)
        expect(put: category_path(category) ).to route_to(
          controller: 'categories',
          action: 'update',
          id: category.id.to_s
        )
      end

      it 'PUT#status_form' do
        category = create(:category)
        expect(put: status_categories_path).to route_to(
          controller: 'categories',
          action: 'status_form'
        )
      end
    end

    #============================================
    describe 'Product routing' do
      it 'GET#index' do
        expect(get: products_path).to route_to(
          controller: 'products',
          action: 'index'
        )
      end

      it 'GET#new' do
        expect(get: new_product_path).to route_to(
          controller: 'products',
          action: 'new'
        )
      end

      it 'POST#create' do
        expect(post: products_path).to route_to(
          controller: 'products',
          action: 'create'
        )
      end

      it 'GET#edit' do
        product = create(:product)
        expect(get: edit_product_path(product) ).to route_to(
          controller: 'products',
          action: 'edit',
          id: product.id.to_s
        )
      end

      it 'PUT#update' do
        product = create(:product)
        expect(put: product_path(product) ).to route_to(
          controller: 'products',
          action: 'update',
          id: product.id.to_s
        )
      end

      it 'PUT#status_form' do
        product = create(:product)
        expect(put: status_products_path).to route_to(
          controller: 'products',
          action: 'status_form'
        )
      end
    end

    #============================================
    describe 'User routing' do
      it 'GET#index' do
        expect(get: users_path).to route_to(
          controller: 'users',
          action: 'index'
        )
      end

      it 'GET#new' do
        expect(get: new_user_path).to route_to(
          controller: 'users',
          action: 'new'
        )
      end

      it 'POST#create' do
        expect(post: users_path).to route_to(
          controller: 'users',
          action: 'create'
        )
      end

      it 'GET#edit' do
        user = create(:user)
        expect(get: edit_user_path(user) ).to route_to(
          controller: 'users',
          action: 'edit',
          id: user.id.to_s
        )
      end

      it 'PUT#update' do
        user = create(:user)
        expect(put: user_path(user) ).to route_to(
          controller: 'users',
          action: 'update',
          id: user.id.to_s
        )
      end

      it 'PUT#status_form' do
        user = create(:user)
        expect(put: status_users_path).to route_to(
          controller: 'users',
          action: 'status_form'
        )
      end

      it 'DELETE#delete_avatar' do
        user = create(:user)
        expect(delete: delete_avatar_user_path(user) ).to route_to(
          controller: 'users',
          action: 'delete_avatar',
          id: user.id.to_s
        )
      end
    end

    #============================================
    describe 'Sessions routing' do
      it 'GET#new' do
        expect(get: new_session_path).to route_to(
          controller: 'sessions',
          action: 'new'
        )
      end

      it 'POST#create' do
        expect(post: sessions_path).to route_to(
          controller: 'sessions',
          action: 'create'
        )
      end

      it 'DELETE#destroy' do
        user = create(:user)
        expect(delete: session_path(user) ).to route_to(
          controller: 'sessions',
          action: 'destroy',
          id: user.id.to_s
        )
      end
    end

    #============================================
    describe 'login and logout routing' do
      it 'login route' do
        expect(get: log_in_path).to route_to(
          controller: 'sessions',
          action: 'new'
        )
      end
      it 'logout route' do
        expect(delete: log_out_path).to route_to(
          controller: 'sessions',
          action: 'destroy'
        )
      end
    end

    it 'root route' do
      expect(get: root_path).to route_to(
        controller: 'sessions',
        action: 'new'
      )
    end

    #============================================

  end
end

