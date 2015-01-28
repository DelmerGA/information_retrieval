class BSTree
  
  class Node < Struct.new(:val,:data, :left, :right)
    def method_missing (m, *args, &block)
      val.method(m).call(*args, &block)
    end
    
  end

  def initialize
    @root = Node.new
  end


  def insert(new_val, data=nil)
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
    current_node.data = data
    self
  end

  def include?(val)
   !find(val).nil?
  end

  def [](char)
    node = find(val)
    node.nil? nil: node,data
  end

  def remove(val)
  end
  
  private
    
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
