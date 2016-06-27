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
    self.bonus = money * 0.10
  end

end

# creation of deliveries object by Delivery class
deliveries = hashed_data.map {|x| Delivery.new(x)}

total_sales = deliveries.map{|x| x.money}.inject(:+)

pilots = deliveries.collect{|x| x.pilot}.uniq

# total earnings for each pilot
pilot_earned = pilots.collect do |x|
  {
    pilot: x,
    revenue: deliveries.select{|y| y.pilot == x}.collect{|z| z.money}.inject(:+)
  }
end
# number of trips each pilot made &
# bonus calculation for each pilot
delivery_bonus = pilots.collect do |x|
  {
    pilot: x,
    deliveries: deliveries.select{|y| y.pilot == x}.length,
    bonus: deliveries.select{|z| z.pilot == x}.collect{|b| b.bonus}.inject(:+)
  }
end


# output to html file
# new_file = File.open("./report.html", "w+")
# new_file << ERB.new(File.read("report.erb")).result(binding)
# new_file.close
