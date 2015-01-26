class Trie
  
  class Node
    attr_reader :chars

    def initialize()
      @chars = {}
      @is_word = false
    end

    def is_word?
      @is_word
    end

    def mark_word(&block)
      @is_word = true
      @data = @data || {}
      if block_given?
        yield @data
      end
    end
    
    def [](char)
      @chars[char]
    end

    def []=(char, val)
      @chars[char] = val
    end

    def mega_traverse_chars (memo, &block)
      stack = [{node: self, memo: memo}]
      result = memo
      until stack.empty?
        node_item = stack.pop
        curr_node = node_item[:node]
        memo = node_item[:memo]
        curr_node.chars.each do |char, node|
          result = block.call(memo, char, node)
          stack.push({node: node, memo: result})
        end
      end
      result
    end

    def traverse_chars(memo, &block)
      result = memo
      @chars.each do |char, node|
        result =  block.call memo, char, node
        result = node.traverse_chars(result, &block)
      end
      result
    end

  end
  
  def initialize
    @root = Node.new
  end

  def learn(word, &block)
    current_node = @root
    word.each_char do |char|
      unless current_node[char]
        current_node[char] = Node.new
      end
      current_node = current_node[char]
    end
    current_node.mark_word(&block)
    self
  end

  def words()
      words_from(@root, "")
  end


  def auto_complete(word)
  
    prefix_node = find(word)
    if prefix_node
      words_from(prefix_node, word)
    end

  end
  
  def to_s
    self.words
  end

  private
  
    def find(sub_word)
      current_node = @root
      sub_word.each_char do |char|
        if current_node[char] == nil
          return nil
        end
        current_node = current_node[char]
      end
      current_node
    end

    def words_from(node, prefix)

      iter = Proc.new do |memo, char, node|
        words = memo[:words]
        new_prefix = memo[:prefix] + char

        if node.is_word?
          words.push(new_prefix)
        end
        {words: words, prefix: new_prefix}
      end
      begin
        start = { words: [], prefix: prefix }
        result = node.traverse_chars(start, &iter)
      rescue SystemStackError => e
        start = { words: [], prefix: prefix }
        result = node.mega_traverse_chars(start, &iter)
      end
      result[:words]
    end

end
