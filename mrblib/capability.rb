class Capability
  class << self
    alias name2cap from_name

    def get_proc
      cap = new
      cap.get_proc
      return cap
    end
  end

  def to_s
    to_text
  end

  def inspect
    "#<Capability #{to_s}>"
  end
end
