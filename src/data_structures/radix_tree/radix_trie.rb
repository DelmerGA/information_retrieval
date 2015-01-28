require_relative("../binary_search_tree/binary_search_tree.rb")
class Radix
  class Node
    attr_accessor :chars
    def initialize
      @chars = BSTree.new
    end

    def []=(char, other)
      @chars.insert(char, {data: other})
    end
    
    def [](char)
      @chars[char]
    end
    private


      def insert_index(char, char_list, start, last)
        puts start
        puts last
        index = (start + last)/2

        if (last <= start)
          return index
        elsif (char_list[index] < char)
          return insert_index(char, char_list, index + 1, last)
        else
          return insert_index(char, char_list, start, index)
        end
      end
  end
end
