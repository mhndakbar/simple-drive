class Base64Decoder
  def self.decode(data)
    if base64?(data)
      Base64.decode64(data)
    else
      nil
    end
  end

  def self.base64?(data)
    !!(data =~ /^[a-zA-Z0-9\/\+=]+\z/)
  end
end