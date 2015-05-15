Rails.application.routes.draw do

  resources :categories, except: :destroy do
    collection do
      put 'status' => 'categories#status_form'
    end
  end

  resources :products, except: :destroy do
    collection do
      put 'status' => 'products#status_form'
    end
  end
  delete '/products/:id/delete/images/:pic_id' => 'products#delete_image', as: :delete_image

  resources :users, except: :destroy do
    collection do
      put 'status' => 'users#status_form'
    end
    delete 'delete/avatar' => 'users#delete_avatar', as: :delete_avatar, on: :member
  end

end
