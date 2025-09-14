# ADR-2: How to display the detailed diagram of the probabilities

**Status:** Accepted

## Context

I want to display a diagram of the detailed probability distribution. It should dynamically change the axis depending on
the sizes of the inputs (amount of datapoints plus the values of the individual datapoints). It should display it in
landscape mode. It would also be great, if individual columns could be clicked and then show their exact value (their
height).

The diagram should:

* show the option that the attacker wins on the left
    * in green
    * x-axis is the losses of the attacker; ascending
* show the option that the defender wins on the right
    * in red
    * x-axis is the losses of the defender; descending
* use the same y-axis (or at least in terms of the values that are shown) for both left and right
* have a small break of empty space in between left and right

## Considered Options

* charts_flutter
    * by google
    * interactive
* fl_chart
    * bar touch handling

To get a feeling, I will ask claude to show two examples, one with each library.

## Decision

I will go with fl_chart. The example with charts_flutter prepared by AI didn't work and the one with fl_chart looks just
like I want it to look. So I don't see any reason for further investigation and for now I will simply use fl_chart.

