Rails.application.routes.draw do
  root "top#index"

  # ログインログアウト
  resource :session, only: [:new, :create, :destroy]

  # 購入者登録
  resource :accounts, only: [:new, :create]

  # 出品者登録
  resource :seller, only: [:new, :create, :update]

  # 出品者トップ
  get "seller/top", to: "sellers#top", as: :seller_top

  # 出品者詳細
  get "/sellers/:id", to: "sellers#show", as: :seller_show

  # 通報機能
  resources :reports, only: [:create]

  # 出品者登録および関連リソース
  namespace :seller do
    resources :items, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :rooms, only: [:index, :new, :create, :edit, :update, :destroy]
    resources :orders, only: [:index, :edit] do
      resources :order_items, only: [:update]
    end
  end

  # 商品一覧, レビュー
  resources :items, only: [:index, :show] do
    resources :reviews, only: [:index, :new, :create, :edit, :update, :destroy]
  end

  # マイページ
  resources :users, only: [:show, :edit, :update, :destroy] do
    collection do
      get :search
    end
    resources :favorites, only: [:index, :create, :destroy]
    resources :reviews, only: [:index]
  end

  # チャット機能
  resources :rooms, only: [:index, :show, :create, :new] do
    resources :messages, only: [:create]
  end

  # カート
  resource :cart, only: [:show] do
    post :add
  end
  resources :cart_items, only: [:create, :update, :destroy]

  # 注文履歴
  resources :orders, only: [:index, :show, :create] do
    collection do
      get :confirm
    end
    member do
      get :status
      patch :status
      post :return
      post :cancel
    end
    resource :review, only: [:new, :create]
  end

  # 管理者
  namespace :admin do
    # 管理者トップ
    get "/", to: "top#index", as: :top
    # アカウント管理
    resources :users
    resources :sellers, only: [:index, :show, :edit, :update, :destroy]
    # 商品管理
    resources :items, only: [:index, :show, :edit, :update, :destroy]
    # 注文管理
    resources :orders, only: [:index, :show, :edit, :update, :destroy] do
      resources :order_items, only: [:update,]
    end
    resources :order_items, only: [:update,]
    # 問い合わせ管理
    resources :rooms, only: [:index, :show, :new, :create, :edit, :update, :destroy]

    # カテゴリ管理
    resources :categories, only: [:index, :new, :create, :edit, :update, :destroy]

    # 通報管理
    resources :reviews, only: [:show, :index, :edit, :update, :destroy]
  end
end
