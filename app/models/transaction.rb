class Transaction < ApplicationRecord
  enum symbol: {
    eosusdt: "eosusdt",
    ltcusdt: "ltcusdt"
  }
  enum tr_type: {
    sell: "sell",
    buy: "buy"
  }
end
