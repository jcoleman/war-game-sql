with recursive
  simulation_hands as (
    -- Initial data: first hand each player starts with
    -- their randomly dealt packet (calculated previously).
    select 1 as hand, player_index, packet
    from (values
      (1, 1, ARRAY[1,4,2,3]),
      (1, 2, ARRAY[4,3,1,2])
    ) as t(hand, player_index, packet)
  ),

  last_simulation_hand_packets as (
    -- Find the most recently played hand and the packet
    -- each player had at that point in the game.
    select *
    from simulation_hands
    where simulation_hands.hand = (
      select max(h2.hand)
      from simulation_hands h2
    )
  )

-- Remove the last card from each player's packet and determine
-- what card will be played in opposition.
select
  player_index,
  packet[1:(array_length(packet, 1) - 1)] as retained_cards,
  coalesce(packet[array_length(packet, 1)], -1) as last_card,
  (
    select array_agg(p2.packet[array_length(p2.packet, 1)])
    from last_simulation_hand_packets p2
  ) as pending_cards,
  coalesce((
    select max(p3.packet[array_length(p3.packet, 1)])
    from last_simulation_hand_packets p3
    where p3.player_index != last_simulation_hand_packets.player_index
  ), -1) as max_opposing_card
from last_simulation_hand_packets;
