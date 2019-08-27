require "nokogiri"
require "open-uri"

class LotteryTicketsController < ApplicationController
  def index
    # 拉取数据

    # 大乐透
    # https://chart.cp.360.cn/kaijiang/slt?lotId=120029&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.4737224711308283#roll_132
    doc = Nokogiri::HTML(
      open("https://chart.cp.360.cn/kaijiang/slt?lotId=120029&chartType=undefined&spanType=2&span=2000-01-01_#{Date.current.to_s}&r=0.4737224711308283")
    )

    items = []

    doc.css("#his-tab .his-table tbody tr").each do |tr|
      items << {
        issue_numer: tr.children[0].content,
        red_balls: tr.children[2].content.split(tr.children[2].content.last),
        blue_balls: tr.children[3].content.split(tr.children[3].content.last),
      }
    end
    items.each do |item|
      if Lotto.find_by(issue_numer: item[:issue_numer]).blank?
        Lotto.create(item)
      end
    end
    # Lotto.create(items)
    @lottos = Lotto.all


    # 双色球
    # https://chart.cp.360.cn/kaijiang/ssq?lotId=220051&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.15824218280087576#roll_132
    doc = Nokogiri::HTML(
      open("https://chart.cp.360.cn/kaijiang/ssq?lotId=220051&chartType=undefined&spanType=2&span=2000-01-01_#{Date.current.to_s}&r=0.15824218280087576")
    )

    s_items = []

    doc.css("#his-tab .his-table tbody tr").each do |tr|
      s_items << {
        issue_numer: tr.children[0].content,
        red_balls: tr.children[2].content.split(tr.children[2].content.last),
        blue_balls: [tr.children[3].content]
      }
    end
    s_items.each do |item|
      if TwoColorBall.find_by(issue_numer: item[:issue_numer]).blank?
        TwoColorBall.create(item)
      end
    end
    # TwoColorBall.create(s_items)
    @two_color_balls = TwoColorBall.all
  end

  def lotto_rates
    totals = Lotto.all.size
    red_numbers = Lotto.pluck(:red_balls).flatten
    @red_ball_rates = (1..35).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        rate: helpers.number_to_percentage(red_numbers.select{ |x| x == num }.size.to_d / totals * 100, precision: 2)
      }
    end
    blue_numbers = Lotto.pluck(:blue_balls).flatten
    @blue_ball_rates = (1..12).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        rate: helpers.number_to_percentage(blue_numbers.select{ |x| x == num }.size.to_d / totals * 100, precision: 2)
      }
    end
  end

  def two_color_rates
  end
end
