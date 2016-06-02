module AddressesHelper
  def display_address(address)
    capture do
      concat content_tag :p, address.name
      concat content_tag :p, address.street_line_1
      concat content_tag :p, address.street_line_2 if address.street_line_2
      concat content_tag :p, address.street_line_3 if address.street_line_3
      concat content_tag :p, address.country
      concat content_tag :p, "#{address.city} #{address.state} #{address.zip_code}"
    end
  end
  
  def display_admin_address(address, label=nil)
    return "no address provided" unless address
    content_tag :address do
      concat content_tag :strong, label if label
      concat content_tag :p, address.name if address.name
      concat content_tag :p, address.street_line_1
      concat content_tag :p, address.street_line_2 if address.street_line_2
      concat content_tag :p, address.street_line_3 if address.street_line_3
      concat content_tag :p, address.country
      concat content_tag :p, "#{address.city} #{address.state} #{address.zip_code}"
    end
  end
end