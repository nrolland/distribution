# This models a distribution
# multidimensional distribution are represented as nested distribution
require 'symbol'

class Distribution
  include Enumerable

  def initialize(undl)
    if undl.class.name == "Array" then
      n = 0
      undl =  undl.inject(Hash.new) {  |res, i| res[n.to_s ] = i;  n +=1; res }
    end

    undl.each_pair { |index, value|
      s = value.class.name
        if s == "Array" || s == "Hash"
          undl[index] = Distribution.new(value)
        end
    }

    @undl = undl
  end

  def entropy
    - self.inject(0) { |res, elem| res += elem["proba"] * Math.log(elem["proba"]); res} / Math.log(2)
  end


  def symbols
      @undl.keys
  end
  def probas
      @undl.values
  end
  def each_outcome_index
 #   p @undl
    @undl.each_key { |index|
#      p index,  @undl[index]
      if @undl[index].class.name == self.class.name
#        p  @undl[index]
        @undl[index].each_key{ |index2|
#          p [index, index2],  @undl[index][index2]
          yield [index, index2],  @undl[index][index2]
          }
      else
        yield index, @undl[index]
      end
    }
end

 def [] (index)
    @undl[index]
 end

  def each_key
    @undl.each_key{|index| yield index}
  end

  def each
    self.each_outcome_index { |i, probai|
      a = {"proba" => probai}
     # p i, probai

      yield a
    }
  end
end

#
#a = Distribution.new([0.5,0.5])
#puts a.entropy
#a = Distribution.new([0.4,0.6])
#puts a.entropy
#a = Distribution.new([0.25,0.75])
#puts a.entropy
#a = Distribution.new([0.2,0.8])
#puts a.entropy
#a = Distribution.new([0.1,0.9])
#puts a.entropy



a = Distribution.new([[0.5,0.25],[0.5,0.75]])
puts a.entropy


a=  {"1" => 1 , "2" => 2}
#
#puts a.class.name

