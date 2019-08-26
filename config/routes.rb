Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :lottery_tickets, only: [:index] do
    collection do
      post :get_history
    end
  end
end

# 拉取数据

# 大乐透
# https://chart.cp.360.cn/kaijiang/slt?lotId=120029&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.4737224711308283#roll_132

# 双色球
# https://chart.cp.360.cn/kaijiang/ssq?lotId=220051&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.15824218280087576#roll_132