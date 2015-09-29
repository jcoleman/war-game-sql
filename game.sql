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
  simulation_hands (hand, packet_1, packet_2, pending_cards, war_count, winner) as (
    select
      1 as hand,
      (select packet from player_packets where player_index = 0) as packet_1,
      (select packet from player_packets where player_index = 1) as packet_2,
      array[]::integer[],
      0,
      null::integer

    union all

    (
      select
        hand + 1 as hand,
        (case simulation_hand_calculations.winner when 1 then simulation_hand_calculations.pending_cards || retained_packet_1 else retained_packet_1 end),
        (case simulation_hand_calculations.winner when 2 then simulation_hand_calculations.pending_cards || retained_packet_2 else retained_packet_2 end),
        (case when simulation_hand_calculations.winner is null then simulation_hand_calculations.pending_cards else array[]::integer[] end),
        (
          case
          when last_simulation_results.winner is not null and simulation_hand_calculations.winner is null
          then last_simulation_results.war_count + 1
          else last_simulation_results.war_count
          end
        ),
        simulation_hand_calculations.winner
      from (
        select *
        from simulation_hands
        order by hand desc
        limit 1
      ) last_simulation_results
      inner join lateral (
        select
          last_simulation_results.packet_1[1:(array_length(packet_1, 1) - 1)] as retained_packet_1,
          last_simulation_results.packet_2[1:(array_length(packet_2, 1) - 1)] as retained_packet_2,
          array[
            coalesce(packet_1[array_length(packet_1, 1)], -1),
            coalesce(packet_2[array_length(packet_2, 1)], -1)
          ] as last_cards
      ) simulation_hand_precalculations on true
      inner join lateral (
        select
          (
            select array_agg(c.n order by random())
            from unnest(last_cards || last_simulation_results.pending_cards) c(n)
            where c.n > -1
          ) as pending_cards,
          (
            case
            when last_cards[1] = last_cards[2] then null::integer
            when last_cards[1] > last_cards[2] then 1
            else 2
            end
          ) as winner
      ) simulation_hand_calculations on true
      where
        not (
          packet_1 = packet_2 -- stalemate
          or array_length(packet_1, 1) = 0
          or array_length(packet_2, 1) = 0
          or hand > 10000 -- safety kill switch for development; remove in final version
        )
    )
  )

select * from simulation_hands