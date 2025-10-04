For large inputs, I run into issues. I tracked it down and this happens only in the safe-attack mode. There, the
critical point is the calculation of a binomial coefficient, where currently I simply calculate the factorials and
divide them by another. These numbers become too big. I was searching for implementations for binomial coefficient
calculation, and it turns out there isn't a suitable yet for dart (probably). I first thought about building something
myself, e.g. by simply copying something from a language like Python where it should already exist. But maybe the
simplest way forward is to just use BigInt or something like that. I assume the individual factorials just become too
big for the data type I'm currently using. So I'll try this first.