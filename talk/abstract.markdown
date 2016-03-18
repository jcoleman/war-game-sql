Abstract
____

Maybe you played the card game War as a child, but you've likely avoided it as an adult. All the skill in the world will never increase your probability of winning beyond that of a coin flip. But even if you have played it recently, I'm almost positive that you've never considered writing a simulation (computer vs. computer) of the game...at least not in SQL.

Common table expressions on their own are an excellent tool for SQL query composition. Luckily for us PostgreSQL takes them one giant step further by providing support for recursion in CTEs. So for this talk I've taken the challenge and written a simulation of War in SQL. Then I had to rewrite it two more times just to find a solution that fit within the limitations PG places on recursive CTEs. We'll begin by considering how to frame the problem space and then work through each of my "solutions". Along the way we'll discover several of the unexpected limitations of recursive CTEs and learn how to use them correctly. 


Organizer Note
____

It's often hard to exercise/demonstrate complex (usage of) features without using an example that requires a lot of problem-specific context. The card game War is likely shared context for many, and easy to explain for others, but still tests the boundaries of what you can accomplish with recursive CTEs.

Bio
____

James Coleman is a backend software engineer at Braintree Payments. He delights in advocating that the database to be treated as a real layer in application development and that PostgreSQL be used to fill that role whenever possible. He also has extensive experience in developing full-stack Rails applications as well as native mobile applications on iOS.

