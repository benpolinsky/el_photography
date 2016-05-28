module DateTimeScopes

  extend ActiveSupport::Concern

  included do
    date_time_methods = []
    
    columns.each {|c| date_time_methods << c.name.gsub(/(_at)\z/, "") if c.type == :datetime}
    
    date_time_methods.each do |m|
      define_singleton_method("recently_#{m}") { order("#{m}_at" => 'desc')}
    end
  end

  
  module ClassMethods
   
  end
  
end