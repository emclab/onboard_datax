Rails.application.routes.draw do

  mount OnboardDatax::Engine => "/onboard_datax"
  mount Commonx::Engine => "/commonx"
  mount Authentify::Engine => '/authentify'
  mount Searchx::Engine => '/searchx'
  mount SwModuleInfox::Engine => '/sw_module'
  mount OnboardDataUploadx::Engine => '/data_upload'
  mount StateMachineLogx::Engine => '/sm_log'
  mount BizWorkflowx::Engine => '/biz_wf'
  mount Kustomerx::Engine => '/customer'
  mount InfoServiceProjectx::Engine => '/project'
  mount ProjectMiscDefinitionx::Engine => '/definition'
  
  resource :session
  
  root :to => "authentify::sessions#new"
  match '/signin',  :to => 'authentify::sessions#new'
  match '/signout', :to => 'authentify::sessions#destroy'
  match '/user_menus', :to => 'user_menus#index'
  match '/view_handler', :to => 'authentify::application#view_handler'
end
