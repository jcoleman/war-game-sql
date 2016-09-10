with recursive
  deck_cards as (
    select face_values.card, suits.i as suit
    from generate_series(1, 13) as face_values(card)
    cross join generate_series(1, 4) as suits(i)
    order by random()
  ),
  deck_cards_with_player_indices as (
    select (row_number() over ()) % 2 as player_index, deck_cards,card
    from deck_cards
  ),
  player_packets as (
    select player_index, array_agg(card) as packet
    from deck_cards_with_player_indices
    group by player_index
  ),
  simulation_hands as (
    -- Initial data: first hand each player starts with
    -- their randomly dealt packet (calculated previously).
    select 1 as hand, player_index, packet
    from player_packets

    -- We just want to keep appending to our result set
    -- rather than having PG check for uniqueness.
    union all

    (
      with last_simulation_hand_packets as (
        -- Find the most recently played hand and the packet
        -- each player had at that point in the game.
        select *
        from simulation_hands
        where simulation_hands.hand = (
          select max(h2.hand)
          from simulation_hands h2
        )
      ),
      simulation_hand_precalculations as (
        -- Remove the last card from each player's packet and determine
        -- what card will be played in opposition.
        select
          player_index,
          packet[1:(array_length(packet) - 1)] as retained_cards,
          coalesce(packet[array_length(packet)], -1) as last_card,
          (
            select array_agg(p2.packet[array_length(p2.packet)])
            from last_simulation_hand_packets p2
          ) as pending_cards,
          coalesce((
            select max(p3.packet[array_length(p3.packet)])
            from last_simulation_hand_packets p3
            where p3.player_index != last_simulation_hand_packets.player_index
          ), -1) as max_opposing_card
        from last_simulation_hand_packets
      ),
      simulation_hand_calculations as (
        -- Determine what cards each player will definitely keep in their packet,
        -- what cards are in play, and who won (if either player did).
        select
          player_index,
          retained_cards,
          -- Shuffle the "in play" cards to avoid potential cycles.
          (select * from unnest(pending_cards) order by random()) as pending_cards,
          (
            case
            when last_card = max_opposing_card then null
            when last_card > max_opposing_card then true
            else false
            end
          ) as winner
        from simulation_hand_precalculations
      )
      -- Return each player's resulting hand after cards have been played.
      select
        (select max(simulation_hands.hand) + 1 from simulation_hands) as hand,
        player_index,
        (case when winner then pending_cards || packet else packet end) as packet
      from simulation_hand_calculations
      where
        1 > (
          -- Either one player has all of the cards (that is, there's only one player_index)
          -- or there are multiple player indices but the packets are all equal (stalemate).
          select count(distinct(player_index, player_packet))
          from last_simulation_hand_packets
          where array_length(player_packet) > 0
        )
    )
  )

select * from simulation_hands;
