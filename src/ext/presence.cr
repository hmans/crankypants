struct Nil
  def presence
    nil
  end
end

class String
  def presence
    blank? ? nil : self
  end
end
