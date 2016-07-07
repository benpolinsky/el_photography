class Theme < ApplicationRecord
  def self.active
    Theme.where(active: true).first
  end
  
  def inactive?
    !active?
  end
  
  def activate!
    update(active: true)
  end
  
  def deactivate!
    update(active: false)
  end
end
