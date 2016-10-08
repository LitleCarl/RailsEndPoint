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

        # 获取楼层房间
        get :rooms
      end

      collection do
        # 所有楼层->所有房间->房间内的基站 隐射表
        get :station_mapping
      end
    end

    # 基站数据更新
    resources :stations, only: [:update]

    # 班级
    resources :clazzs, only: [:index, :update, :create]

    # 语音消息
    resources :audio_messages do
      member do
        # 设置已读
        post :set_read
      end
    end

    # 老师
    resources :teachers do
      collection do
        # 获取评论
        get :comments

        get :audio_messages

        # 获取魔法棒配置
        get :sticker_configs

        # 更新魔法棒配置
        post :update_sticker_config

        # 添加魔法棒配置
        post :create_sticker_config
      end
    end

    # 轨迹
    resources :tracks, only: [:create]
  end

  namespace :board do
    # 养老院
    resources :nursing_home, only: [:index] do
      collection do
        # 获取页面数据
        get :page_data
      end
    end

    # 班级
    resources :clazzs, only: [:index, :show] do
      member do
        get :students_list
        get :comments
      end

      collection do
        # 创建评论
        post :create_comment

        # 创建语音信息
        post :create_audio_message

        # 获取教师列表接口
        get :teachers
      end
    end


  end

end
