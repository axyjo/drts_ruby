DrtsRuby::Application.routes.draw do
  ActiveAdmin.routes(self)

  devise_for :admin_users, ActiveAdmin::Devise.config

  devise_for :users

  get "empires/list", :as => "empires_list"
  get "empires/choose/:id" => "empires#choose", :as => "empires_choose"

  get "coordinates/:x/:y" => "coordinates#view"
  get "maps/view"

  match "/chat/send" => "chats#new"

  resources :admin

  root :to => "maps#view"

end
