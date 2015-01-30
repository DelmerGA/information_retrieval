class BSTree
  
  class Node < Struct.new(:val,:data, :left, :right)
    def method_missing (m, *args, &block)
      val.method(m).call(*args, &block)
    end
    
    def empty?
      val.nil?
    end
  end

  def initialize
    @root = Node.new
  end

  def to_a
    arr = []
    stack = [{node: @root, side: 1}]
    until stack.empty?
      current = stack.pop
      unless current[:node].nil?
        if current[:side] == 1
          stack.push current
          stack.push({node: current[:node].left, side: 1})
        elsif current[:side] == 2
          arr.push current[:node].val
          stack.push({node: current[:node].right, side: 1})
        else
          arr.push stack.pop.val
        end
      else
        next_node = stack.last
        if next_node
          next_node[:side] += 1
        end
      end
    end
    arr
  end

  def insert(new_val, data=nil)
    current_node = @root
    
    until current_node.empty?
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
    node.empty? ? nil: node.data
  end

  def rotate_left!
    if @root.right
      right = @root.right
      @root.right = right.left
      right.left = @root
      @root = right
    end
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
