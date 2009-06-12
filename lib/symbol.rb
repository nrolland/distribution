class Symbol
  def to_proc
    proc{|obj| obj.send(self) }
  end
end
