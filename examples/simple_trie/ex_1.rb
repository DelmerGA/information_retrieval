require_relative("../src/data_structures/simple_trie/trie.rb")

t = Trie.new
t.learn("better").learn("bet").learn("best")
t.learn("begin").learn("began").learn("beginner")

t.learn("better")

puts t.words


