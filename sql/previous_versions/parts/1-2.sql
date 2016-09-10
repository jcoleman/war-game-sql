with recursive
  simulation_hands as (
    -- Initial data: first hand each player starts with
    -- their randomly dealt packet (calculated previously).
    select 1 as hand, player_index, packet
    from (values
      (1, 1, ARRAY[1,4,2,3]),
      (1, 2, ARRAY[4,3,1,2])
    ) as t(hand, player_index, packet)
  )

select *
from simulation_hands
where simulation_hands.hand = (
  select max(h2.hand)
  from simulation_hands h2
);
