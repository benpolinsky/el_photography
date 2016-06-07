class MockCard
  def initialize(args)
    number = args[:number]
    exp_month = args[:exp_month]
    exp_year = args[:exp_year]
    cvv = args[:cvv]
    {number: number, exp_month: exp_month, exp_year: exp_year, cvv: cvv}
  end
  
  def self.new_valid(args={})
    number = args[:number] || 4242424242424242
    exp_month = 02
    exp_year = 2020
    cvv = 123
    {number: number, exp_month: exp_month, exp_year: exp_year, cvv: cvv}
  end
  
  def self.new_failing
    new_valid(number: 4000000000000002)
  end
  
end