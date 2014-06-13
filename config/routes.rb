OnboardDatax::Engine.routes.draw do
  resources :onboard_engine_configs do
    collection do
      get :search
      get :search_results  
    end
  end
  resources :onboard_engine_inits do
    collection do
      get :search
      get :search_results  
    end
  end
  resources :onboard_user_accesses do
    collection do
      get :search
      get :search_results  
    end
  end
  resources :onboard_search_stat_configs do
    collection do
      get :search
      get :search_results  
    end
  end

end
