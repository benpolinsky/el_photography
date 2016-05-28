module ArrayExtensions
  refine Array do
    alias_method :multiply, :product
  end
end