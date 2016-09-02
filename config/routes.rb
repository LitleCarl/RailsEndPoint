Rails.application.routes.draw do
  resources :users do
    collection do
      get :sign_in
      post :sign_in
      get :me
    end
  end

  resources :seeds do
    collection do
      post :create_payload
    end
  end

  # 楼层
  resources :floors, only: [:index, :create, :edit, :new, :show]

  namespace :api do
    # 统计API
    resources :statistics, only: [:index]

    resources :rooms do
      member do
        post :create_station
      end
    end

    # 楼层API
    resources :floors, only: [:index, :show] do
      member do
        post :create_room
      end
    end

  end
end
