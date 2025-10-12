I want my diagram to feel nice to look at. It should cover all edge cases. It should display the binomial distribution
such that it's easy for the eye to grasp it. This means, that the x-axes must use the same scale, so that the columns
resemble one smooth curve across the two diagrams. This is difficult, because in principle very distinct inputs are
possible. For example if the attackers have 120 troops and the defenders 120, then it's easy and there is no formatting
magic necessary. But if the defender has only 80, then the attackers diagram should take 3/5 of the total available
space, while the defender diagram takes only 2/5. The sizes of the two boxes must be dynamically calculated from the
total attackers and defenders. What happens though when it's 120 vs 5? In this case there wouldn't even be enough space
to display the heading of the defenders diagram.
This is not all: For large values, there is usually a long tail with negligible probabilities. With 120 vs 120, the
interesting stuff happens only from 70-119 losses of the attacker to 119-65 losses of the defender. So all values
outside of this area give no value to the user of the app and just steal away the space for the display of the areas
where something interesting happens. I would like to use a cutoff here. I assume that a static value is enough, but in
the best option would be to use a value that is relative to the height of the diagram.
What do I do in case that this cutoff takes effect for all values of either the left or the right half? I should only
display the other half and add a short explanation to the title. And what to do if one of the two becomes so small, that
I can't display the heading anymore? I think I need to move the heading of the two diagrams to the containing widget. 