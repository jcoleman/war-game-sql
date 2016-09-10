Shall We Play a Game? (with CTEs)
_____

Introduction (3-5 minutes)
----

1. Personal Background
  - I'm a software engineer at Braintree Payments.
  - Twitter: @jt_coleman
  - Github: https://github.com/jcoleman
2. Talk Background
  - Inspiration: interview question (in another language)
  - What if...I could do this in SQL? 
3. Roadmap
  - Why should you attend this talk?
    - CTEs are incredibly powerful.
    - Recursive support makes CTEs even more powerful, but they can be very confusing.
    - This is a (hopefully) fun way to learn the power of (recursive) CTEs.
  - How are we going to accomplish that?
    - Describe the problem space (using sets!)
    - Work through two false-starts and examine some of the limitations of recursive CTEs that those attempts revealed.
    - Work through the final working solution.
    - ...And we'll leave some time at the end for Q/A.


Review (3 minutes)
----

1. Common table expressions
2. Recursive common table expressions


Problem Space (5 minutes
----
1. Explain War card game.
2. Step back: How would we do this procedurally?
  - Pseudocode an example?
3. But how do we express this in a set language?
  - Conceptually, I think it's easier (though the details might plague us).
  - My attempt:
    The ordered set of tuples containing the winner of that play and each player's hand of cards where each subsequent tuple is the result of `f(n-1)`.
  - What's missing?
    That definition left out two key pieces of information: how we start and how we end. So let's re-write it:
    The ordered set of tuples containing the winner of that play and each player's hand of cards where
    _the first tuple has a null winner and each player's hand of randomly dealt cards_
    with each subsequent tuple being the result of `play_war(previous_tuple)`
    _until one of the player's hands is empty._
  - So we have something really interesting here: we've basically written the definition of a recursive function: we have a 1.) base case and 2.) a recursive form (+ an initial value).
  - ...And that sounds like a candiate for recursive CTEs.


Failed Attempt One
----

Description: tuple (hand, player, card array)

Lessons:
1. PG doesn't allow multiple references to the recursive CTE in the recursive component
2. PG doesn't allow references to the recursive CTE in subqueries (at least ones not in the FROM section of the recursive component.)


Failed Attempt Two
----

Description: tuple (hand, array of card arrays)

Lessons:
1. PG multi-dimensional arrays are actually matrices.
2. Software engineering: don't overly genercize solution (there will only ever be two players in this game as we're considering it)


Working Solution
----

Description: tuple (hand, array of player one's cards, array of player two's cards...)

Lessons:
1. Ordering in aggregates is controlled separately from the statement level ORDER BY


Other Notes
----

1. FALSE: You cannot have nested recursive CTEs

