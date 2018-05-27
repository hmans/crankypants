struct Time
  def to_iso8601
    to_s("%FT%X%:z")
  end
end
