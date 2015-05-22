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

    it 'DELETE#delete_image' do
      
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
end

