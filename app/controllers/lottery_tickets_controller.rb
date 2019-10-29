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
    totals = TwoColorBall.all.size
    red_numbers = TwoColorBall.pluck(:red_balls).flatten
    @red_ball_rates = (1..33).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        rate: helpers.number_to_percentage(red_numbers.select{ |x| x == num }.size.to_d / totals * 100, precision: 2)
      }
    end
    blue_numbers = TwoColorBall.pluck(:blue_balls).flatten
    @blue_ball_rates = (1..16).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        rate: helpers.number_to_percentage(blue_numbers.select{ |x| x == num }.size.to_d / totals * 100, precision: 2)
      }
    end
  end

  def get_recomand_balls
    # 大乐透 追冷 追热
    lt_red_numbers = Lotto.pluck(:red_balls).flatten
    lt_red_ball_rates = (1..35).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        count: lt_red_numbers.select{ |x| x == num }.size
      }
    end
    lt_red_ball_rates = lt_red_ball_rates.sort_by{|x| x[:count] }

    @lt_could_red_balls = lt_red_ball_rates.first(15).sample(5).map{|x| x[:number]}.sort
    @lt_hot_red_balls = lt_red_ball_rates.last(15).sample(5).map{|x| x[:number]}.sort

    lt_blue_numbers = Lotto.pluck(:blue_balls).flatten
    lt_blue_ball_rates = (1..12).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        count: lt_blue_numbers.select{ |x| x == num }.size.to_d
      }
    end
    lt_blue_ball_rates = lt_blue_ball_rates.sort_by{|x| x[:count] }

    @lt_could_blue_balls = lt_blue_ball_rates.first(6).sample(2).map{|x| x[:number]}.sort
    @lt_hot_blue_balls = lt_blue_ball_rates.last(6).sample(2).map{|x| x[:number]}.sort

    # 是否有中奖历史
    @lt_could_is_v = Lotto.find_by(red_balls: @lt_could_red_balls, blue_balls: @lt_could_blue_balls).present?
    @lt_hot_is_v = Lotto.find_by(red_balls: @lt_hot_red_balls, blue_balls: @lt_hot_blue_balls).present?

    # 双色球 追冷 追热
    ss_red_numbers = TwoColorBall.pluck(:red_balls).flatten
    ss_red_ball_rates = (1..33).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        count: ss_red_numbers.select{ |x| x == num }.size
      }
    end
    ss_red_ball_rates = ss_red_ball_rates.sort_by{|x| x[:count] }

    @ss_could_red_balls = ss_red_ball_rates.first(15).sample(6).map{|x| x[:number]}.sort
    @ss_hot_red_balls = ss_red_ball_rates.last(15).sample(6).map{|x| x[:number]}.sort

    ss_blue_numbers = TwoColorBall.pluck(:blue_balls).flatten
    ss_blue_ball_rates = (1..16).to_a.map do |x|
      num = "%02d" % x
      {
        number: num,
        count: ss_blue_numbers.select{ |x| x == num }.size.to_d
      }
    end
    ss_blue_ball_rates = ss_blue_ball_rates.sort_by{|x| x[:count] }

    @ss_could_blue_balls = ss_blue_ball_rates.first(8).sample(1).map{|x| x[:number]}.sort
    @ss_hot_blue_balls = ss_blue_ball_rates.last(8).sample(1).map{|x| x[:number]}.sort

    # 是否有中奖历史
    @ss_could_is_v = TwoColorBall.find_by(red_balls: @ss_could_red_balls, blue_balls: @ss_could_blue_balls).present?
    @ss_hot_is_v = TwoColorBall.find_by(red_balls: @ss_hot_red_balls, blue_balls: @ss_hot_blue_balls).present?

  end
end
