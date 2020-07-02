# Ellenberg's Values Automaton
To match a given set of plant species with Ellenberg's indicator values:
1. Read csv files with Ellenberg's indicator values, merge them and resort the columns
1. Read file with plant list and shorten the binomial names
1. Fuzzy match species names with `agrep` and store results in a list
1. Update plant list with Ellenberg's indicator values
1. Revise mismatches

## Notes
* Pay attention to synonyms
* To manually revise mismatches, keep in mind that
  * the official list is incomplete what yields zero matches
  * the presence of subspecies and aggregates will yield multiple matches
