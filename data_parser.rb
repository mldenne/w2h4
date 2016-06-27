require 'csv'
require 'erb'

# import of Planet Express data files
data = CSV.read("planet_express_logs.csv", {headers: true, header_converters: :symbol, converters: :all})

hashed_data = data.map{|d| d.to_hash}

# creation of Delivery class
class Delivery

  attr_accessor :destination, :shipment, :crates, :money, :pilot, :bonus

  def initialize(hash)
    @destination = hash[:destination]
    @shipment = hash[:shipment]
    @crates = hash[:crates]
    @money = hash[:money]
    determine_pilot
    determine_bonus
  end

  def determine_pilot
    if destination == "Earth"
      self.pilot = "Fry"
    elsif destination == "Mars"
      self.pilot = "Amy"
    elsif destination == "Uranus"
      self.pilot = "Bender"
    else
      self.pilot = "Leela"
    end
  end

  def determine_bonus
    self.bonus = money.to_f * 0.10
  end

end

# creation of deliveries object by Delivery class
deliveries = hashed_data.map {|x| Delivery.new(x)}

total_sales = deliveries.map{|x| x.money}.inject(:+)

# total earnings for each pilot
fry_earned = deliveries.select{|x| x.pilot == "Fry"}.collect{|y| y.money}.inject(:+)
amy_earned = deliveries.select{|x| x.pilot == "Amy"}.collect{|y| y.money}.inject(:+)
bender_earned = deliveries.select{|x| x.pilot == "Bender"}.collect{|y| y.money}.inject(:+)
leela_earned = deliveries.select{|x| x.pilot == "Leela"}.collect{|y| y.money}.inject(:+)

# bonus calculation for each pilot
fry_bonus = deliveries.select{|x| x.pilot == "Fry"}.collect{|y| y.bonus}.inject(:+)
amy_bonus = deliveries.select{|x| x.pilot == "Amy"}.collect{|y| y.bonus}.inject(:+)
bender_bonus = deliveries.select{|x| x.pilot == "Bender"}.collect{|y| y.bonus}.inject(:+)
leela_bonus = deliveries.select{|x| x.pilot == "Leela"}.collect{|y| y.bonus}.inject(:+)

# number of trips each pilot made
fry_trips = deliveries.count{|x| x.pilot == "Fry"}
amy_trips = deliveries.count{|x| x.pilot == "Amy"}
bender_trips = deliveries.count{|x| x.pilot == "Bender"}
leela_trips = deliveries.count{|x| x.pilot == "Leela"}

# output to html file
new_file = File.open("./report.html", "w+")
new_file << ERB.new(File.read("report.erb")).result(binding)
new_file.close
