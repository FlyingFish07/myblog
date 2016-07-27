Enki::Application.routes.draw do
  devise_for :users, :path => "admin", :controllers => { :omniauth_callbacks => "admin/omniauth_callbacks" }
  get '/admin' => "admin/dashboard#show", as: :user_root
  
  get 'search'  => 'search#show'

  namespace :admin do
    resources :users do
      get 'edit_for_omniauth', :on => :member
      patch 'update_for_omniauth', :on => :member
    end
    # resource :session

    resources :posts, :pages do
      post 'preview', :on => :collection
    end
    resources :comments do
      get 'view', :on => :member
    end
    resources :undo_items do
      post 'undo', :on => :member
    end
    # add upload file
    resources :pubfiles do
      get 'download', :on => :member    
    end
    resources :pubimages do
      get 'download', :on => :member  
    end

    get 'health(/:action)' => 'health', :action => 'index', :as => :health
    post 'health/generate_exception' => 'health#generate_exception'

    root :to => 'dashboard#show'
  end

  resources :archives, :only => [:index]
  resources :pages, :only => [:show]

  constraints :year => /\d{4}/, :month => /\d{2}/, :day => /\d{2}/ do
    get ':year/:month/:day/:slug/comments'  => 'comments#index'
    post ':year/:month/:day/:slug/comments' => 'comments#create'
    get ':year/:month/:day/:slug/comments/new' => 'comments#new'
    get ':year/:month/:day/:slug' => 'posts#show'
  end

  scope :to => 'posts#index' do
    get 'posts.:format', :as => :formatted_posts
    get '(:category)', :as => :posts, :category => /(?:[A-Za-z0-9_ \.-]|%20)+?/, :format => /html|atom/
  end

  # 采用devise，去掉了comment对于omniAuth的支持
  # OmniAuth routes.
  # post 'auth/open_id_comment/callback', :to => 'comments#create'
  # match 'auth/failure' => 'comments#create',
  # :constraints => lambda { |request|
  #   request.query_parameters[:strategy] == ApplicationController::OMNIAUTH_OPEN_ID_COMMENT_STRATEGY
  # }, :via => [:get]
  # post 'auth/open_id_admin/callback', :to => 'admin/sessions#create'
  # match 'auth/:provider/callback', :to => 'admin/sessions#create', :via => [:get, :post]
  # get 'auth/failure/comments/new', :to => 'comments#new'
  # get 'auth/failure', :to => 'admin/sessions#new'

  root :to => 'posts#index'
end
