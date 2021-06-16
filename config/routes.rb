Rails.application.routes.draw do
  root 'dashboard#index'
  get '/pushes/(:type)/(:lang)/(:moment)/(:interval)', to: 'dashboard#pushes'
  get '/:lang/:period', to: 'dashboard#index'
  get '/tools', to: 'dashboard#tools'
end
