class BSTree
  
  class Node < Struct.new(:val, :left, :right)
    def method_missing (m, *args, &block)
      val.method(m).call(*args, &block)
    end
    
  end

  def initialize
    @root = Node.new
  end


  def insert(new_val)
    current_node = @root
    
    until current_node.val.nil?
      if current_node < new_val
        side = :right
      else
        side = :left
      end
      current_node[side] ||= Node.new()
      current_node = current_node[side]
    end

    current_node.val = new_val
    self
  end

  def include?(val)
    compare = Proc.new do |node|
      node.val < val
    end
    matcher = Proc.new {|n| n.val == val }
    !find(compare, matcher).nil?
  end

  def remove(val)
  end
  
  private
     def cust_find(compare, matcher)
      current_node = @root
      until current_node.nil?
        if compare.call(current_node)
            current_node = current_node.right
        else
          current_node = current_node.left
        end
        p current_node
        if current_node && matcher.call(current_node)
          return current_node
        end
      end
    end

    def find(val)
      current_node = @root
      until current_node.nil?
        if current_node < val
            current_node = current_node.right
        else
          current_node = current_node.left
        end
      
        if current_node && current_node.val == val
          return current_node
        end
      end
    end
end