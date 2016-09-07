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

  # 班级
  resources :clazzs, only: [:index, :new, :create, :show]

  namespace :api do
    # 统计API
    resources :statistics, only: [:index] do
      collection do
        post :floor
      end
    end

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

    # 基站数据更新
    resources :stations, only: [:update]

    # 班级
    resources :clazzs, only: [:index]
  end

  namespace :board do
    resources :clazzs, only: [:index, :show] do
      member do
        get :students_list
        get :comments

      end

      collection do
        get :create_comment
      end
    end


  end

end
