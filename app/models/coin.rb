require "huobi_pro"
class Coin < ApplicationRecord
  has_many :transactions

  def symbol
    "#{currency}usdt"
  end

  def balance
    huobi = HuobiPro.new
    ba = huobi.balances["data"]["list"].select{ |x| x["currency"] == currency && x["type"] == "trade" }.first["balance"]
    ba.to_d
  end

  def buy_prices
    huobi = HuobiPro.new
    max_p = huobi.market_trade("#{currency}usdt", "step0")["tick"]["asks"].last.first
    min_p = huobi.market_trade("#{currency}usdt", "step0")["tick"]["asks"].first.first
    [min_p, max_p]
  end

  def sell_prices
    huobi = HuobiPro.new
    max_p = huobi.market_trade("#{currency}usdt", "step0")["tick"]["bids"].first.first
    min_p = huobi.market_trade("#{currency}usdt", "step0")["tick"]["bids"].last.first
    [min_p, max_p]
  end

  def buy_in(price)
    huobi = HuobiPro.new
    # 市价 买入
    resp = huobi.custom_new_order(symbol, "buy", investment_amount)
    if resp["status"] == "ok"
      transactions.create(
        symbol: symbol,
        price: price,
        amount: investment_amount,
        tr_type: "buy"
      )
    end
  end

  def sell_out(price)
    huobi = HuobiPro.new
    # 市价 卖出
    sell_amount = balance
    resp = huobi.custom_new_order(symbol, "sell", sell_amount)
    if resp["status"] == "ok"
      transactions.create(
        symbol: symbol,
        price: price,
        amount: sell_amount,
        tr_type: "sell"
      )
    end
  end

  def self.auto_transcation
    loop do
      sleep 30
      p "auto transaction......."
      Coin.find_each do |coin|
        next if coin.currency != "eos"
        last_trans = coin.transactions.send(coin.symbol).last
        if last_trans&.sell? || last_trans.blank?
          # 最后一次交易 是卖出, 所以需要买入
          min_buy_price, max_buy_price = coin.buy_prices
          last_sell_price = coin.transactions.send(coin.symbol).sell.last&.price || coin.basic_price
          # 满足低买
          if (min_buy_price <= (last_sell_price - coin.entent)) && (max_buy_price < last_sell_price)
            evge_price = (min_buy_price + max_buy_price) / 2
            coin.buy_in(evge_price)
          end
        else
          # 需要卖出
          min_sell_price, max_sell_price = coin.sell_prices
          last_buy_price = coin.transactions.send(coin.symbol).buy.last&.price
          # 满足高卖
          if (max_sell_price >= (last_buy_price + coin.entent)) && (min_sell_price > last_buy_price)
            evge_price = (min_sell_price + max_sell_price) / 2
            coin.sell_out(evge_price)
          end
        end
      end
    end
  end
end
