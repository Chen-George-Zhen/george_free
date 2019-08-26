require "nokogiri"
require "open-uri"

class LotteryTicketsController < ApplicationController
  def index
    # 拉取数据

    # 大乐透
    # https://chart.cp.360.cn/kaijiang/slt?lotId=120029&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.4737224711308283#roll_132
    doc = Nokogiri::HTML(
      open("https://chart.cp.360.cn/kaijiang/slt?lotId=120029&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.4737224711308283")
    )

    @items = []

    doc.css("#his-tab .his-table tbody tr").each do |tr|
      @items << {
        number: tr.children[0].content,
        five: tr.children[2].content,
        two: tr.children[3].content,
      }
    end


    # 双色球
    # https://chart.cp.360.cn/kaijiang/ssq?lotId=220051&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.15824218280087576#roll_132
    doc = Nokogiri::HTML(
      open("https://chart.cp.360.cn/kaijiang/ssq?lotId=220051&chartType=undefined&spanType=2&span=2000-01-01_2019-08-26&r=0.15824218280087576")
    )

    @s_items = []

    doc.css("#his-tab .his-table tbody tr").each do |tr|
      @s_items << {
        number: tr.children[0].content,
        five: tr.children[2].content,
        two: tr.children[3].content,
      }
    end

  end

  def get_history
  end
end
