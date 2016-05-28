class PublishingService
  attr_accessor :model
  attr_reader :conditions
  def initialize(model, *conditions)
    @model = model
    @conditions = conditions.extract_options!
    @conditions.each_pair do |method_name, method_contents|
      define_singleton_method method_name do
        send_chain(@model, (method_contents.split(".")))
      end
    end

  end
  
  def send_chain(model, arr)
    arr.inject(model, :public_send)
  end
  
  def valid?
    @conditions.each_key do |condition|
      return false unless self.public_send(condition)
    end
    true
  end
  
  def list_invalid
    list(:invalid)
  end
  
  def list_valid
    list(:valid)
  end
  
  def pretty_list(choice)
    list(choice).map do |invalid_item|
      invalid_item.to_s.titleize
    end
  end
  
  private
  
  def list(choice)
    the_list = []
    @conditions.each_key do |condition|
      if choice == :valid
        if self.public_send(condition)
          the_list << condition
        end
      else
        unless self.public_send(condition)
          the_list << condition
        end
      end
    end
    the_list
  end
end