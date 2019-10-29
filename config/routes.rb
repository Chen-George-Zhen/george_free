Rails.application.routes.draw do
  root "home#index"

  resources :lottery_tickets, only: [:index] do
    collection do
      get :lotto_rates, :two_color_rates
      get :get_recomand_balls
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end