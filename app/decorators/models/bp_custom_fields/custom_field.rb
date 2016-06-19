BpCustomFields::Field.class_eval do
  def to_liquid
    {
      value: self.value
    }
  end
end