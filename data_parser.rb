require 'csv'

data = CSV.read("planet_express_logs.csv", {headers: true, header_converters: :symbol, converters: :all})

hashed_data = data.map{|d| d.to_hash}


class Delivery

  attr_accessor :destination :shipments :crates :money :pilot :bonus

  def initialize(hash)
    @destination = hash[:destination]
    @shipments = hash[:shipments]
    @crates = hash[:shipments]
    @money = hash[:money]
  end
