require_relative("../../src/data_structures/simple_trie/trie.rb")

trie = Trie.new
line_num = 0
IO.foreach("../texts/alices_adventures_in_wonderland.txt") do | line|
  line_num += 1
  line.scan(/\w+\'?\w+?/) do |m|
    trie.learn(m.downcase) do |data|
      data[:lines] ||= []
      data[:lines].push(line_num)
    end
  end
end

trie.words.each do |word|
  p word
end
