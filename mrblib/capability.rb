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

class Capability::File
  def to_s
    to_text
  end

  def inspect
    "#<Capability::File(#{path}) #{to_s}>"
  end

  alias unset clear
end
