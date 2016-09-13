select face_values.card, suits.i as suit
from generate_series(1, 4) as face_values(card)
cross join generate_series(1, 2) as suits(i)
order by random();
