Rails.application.routes.draw do

  resources :categories, except: :destroy do
    collection do
      put :status, constraints: CommitParamRouting.new(CategoriesController::ACTIVE), action: :active
      put :status, constraints: CommitParamRouting.new(CategoriesController::DEACTIVE), action: :deactive
    end
  end

  resources :products, except: :destroy do
    collection do
      put :status, constraints: CommitParamRouting.new(ProductsController::ACTIVE), action: :active
      put :status, constraints: CommitParamRouting.new(ProductsController::DEACTIVE), action: :deactive
    end
  end
  delete '/products/:id/delete/images/:pic_id' => 'products#delete_image', as: :delete_image

  resources :users, except: :destroy do
    collection do
      put :status, constraints: CommitParamRouting.new(UsersController::ACTIVE), action: :active
      put :status, constraints: CommitParamRouting.new(UsersController::DEACTIVE), action: :deactive
    end
  end

end
