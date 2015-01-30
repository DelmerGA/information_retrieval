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

  def start(frame, &block)
    @stack ||= []
    @stack.push(frame)
    if block
      until @stack.empty?
        result = block.call(complete)
        @stack.last[:result] = result
      end
    end
  end

  def complete
    @stack ||= []
    @stack.pop
  end

  def new_first(&block)
    start({node: @root, count: 0}) do |frame|
      node = frame[:node]
      count = frame[:count]

      if node
        if count == 0
          start({node: node.left, count: 0 })
        elsif count == 1
          frame[:count] = 2
          start(frame)
          start({node: node.right, count: 0})
        else
          block.call(complete)
        end
      else
        next_frame = complete
        if next_frame 
          next_frame[:count] = 2
          start(next_frame)
        end
      end
    end
  end

  def depth_first(&block)
    stack = [{node: @root, side: 1}]
    until stack.empty?
      current = stack.pop
      yield current[:node]
      unless current[:node].nil?
        if current[:side] == 1
          stack.push current
          stack.push({node: current[:node].left, side: 1})
        elsif current[:side] == 2
          stack.push({node: current[:node].right, side: 1})
        else
          yield stack.pop[:node]
        end
      else
        next_node = stack.last
        if next_node
          next_node[:side] += 1
        end
      end
    end
  end

  def each_order(&block)
    stack = [{node: @root, side: 1}]
    until stack.empty?
      current = stack.pop
      unless current[:node].nil?
        if current[:side] == 1
          stack.push current
          stack.push({node: current[:node].left, side: 1})
        elsif current[:side] == 2
          block.call(current[:node].val)
          stack.push({node: current[:node].right, side: 1})
        else
          block.call(stack.pop.val)
        end
      else
        next_node = stack.last
        if next_node
          next_node[:side] += 1
        end
      end
    end
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
