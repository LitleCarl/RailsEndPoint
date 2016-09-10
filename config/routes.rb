Rails.application.routes.draw do
  resources :users do
    collection do
      get :sign_in
      post :sign_in
      get :me
      get :sign_up
      post :sign_up

      get :me_detail
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

    # 老师
    resources :teachers do
      collection do
        # 获取评论
        get :comments

        # 获取魔法棒配置
        get :sticker_configs

        # 更新魔法棒配置
        post :update_sticker_config

        # 添加魔法棒配置
        post :create_sticker_config
      end
    end
  end

  namespace :board do
    resources :clazzs, only: [:index, :show] do
      member do
        get :students_list
        get :comments

      end

      collection do
        post :create_comment
      end
    end


  end

end
