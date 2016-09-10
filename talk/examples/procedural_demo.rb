cards = (1..4).flat_map { (1..13).to_a }.shuffle
hands = cards.partition.with_index { |_, i| i.even? }
until hands.any?(&:empty?)
  played_cards = hands.map { |hand| [hand.pop] }
  until hands.any?(&:empty?) || played_cards[0].last != played_cards[1].last
    hands.each_with_index { |hand, i| played_cards[i] << hand.pop }
  end
  winner = played_cards[0].last < played_cards[1].last ? 1 : 0 # Ignores stalemate
  hands[winner].unshift(*played_cards.flatten.shuffle)
end

hands.each_with_index do |hand, i|
  puts "Player #{i} #{hand.empty? ? 'lost' : 'won'} with #{hand.inspect}"
end

