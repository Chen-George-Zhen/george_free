class LotteryTicket < ApplicationRecord
  validates :type, :issue_numer, :red_balls, :blue_balls, presence: true
end
