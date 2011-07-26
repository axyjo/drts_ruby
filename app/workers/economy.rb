class Economy
  @queue = :economy_queue
  def self.perform
    Empire.all.each do |e|
      income_per_unit = (e.provinces.count * 1000)/e.users.sum(:income_unit)
      e.users.each do |u|
        u.update_attributes(:gold => u.gold + (income_per_unit * u.income_unit))
      end
    end
  end
end