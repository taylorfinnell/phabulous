class String
  def constantize
    names = self.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_get(name, false) || constant.const_missing(name)
    end
    constant
  end

  def demodulize
    if i = self.rindex('::')
      self[(i+2)..-1]
    else
      self
    end
  end
end
