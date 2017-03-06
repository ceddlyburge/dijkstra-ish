# Problem one: Trains

## Running the examples

```bash
ruby examples.rb
```
## Example ouput

Running the examples will output the following statistics, for the network topology defined in network_topology.txt

* The parsed network topology
* The distance of the route A-B-C.
* The distance of the route A-D.
* The distance of the route A-D-C.
* The distance of the route A-E-B-C-D.
* The distance of the route A-E-D.
* The number of trips starting at C and ending at C with a maximum of 3 stops.
* The number of trips starting at A and ending at C with exactly 4 stops.
* The length of the shortest route (in terms of distance to travel) from A to C.
* The length of the shortest route (in terms of distance to travel) from B to B.
* The number of different routes from C to C with a distance of less than 30.

## Archictecture

Lightweight architecture decision records in doc/arch.

Please note that ADR's 003 and 004 have been decided but not yet implemeneted.

## Response to reviewer comments

### There were several things i really liked about your code: a working solution, readability of function names, applying method extraction refactorings and evidence of some small-step TDD. The honest comments and design records also helped me understand your thinking.

Thank you for the kind words.

I would add that the average variable span and live time is short.

The submission was however weak in showing evidence of "object oriented programming skills" we're looking for:
### Encapsulation was weak, e.g. leading to coupling of permutations code into internals of route extension (look for law of demeter violations)

- RouteExtension and RouteCandidate felt like both being routes that were used in slightly different contexts
- really RoutePermutations was doing most (too much) of the work itself
- simple use of instance data, e.g. for the invariant route topology used in route permutations, could have reduced a lot of code
- naming of some classes and methods i found questionable:
### AtomicRoute was awkward naming. a route being composed of atomic routes? would have preferred a route composed of legs or tracks. admittedly, the trains problem is a bit loose with the word 'route' but i found this distracting.

I mostly disagree with this. 

"Atomic" has a well defined meaning that is used elsewhere in computing so should be known by all programmers, and "Route" is in the language of the domain. It is however a bit long and clunky.

"Leg" is short, but does not have a well defined meaning and may not be understandable by all programmers, especially in a globally distributed team, and it is not in the domain.

"Track" is short, and is in the language of the domain, but the domain definition is not well defined.

TODO
I have however, changed AtomicRoute to Leg. If I were to do this in the real world I would want to introduce Leg to the domain.

e.g. in RouteExtension class:
- #atomic_routes - was actually atomic routes without/before extension (or legs without last)
- #atomic_route - was actually the extending/last atomic route
e.g NetworkTopology was really a NetworkTopologyParser. Again, could have been a stronger, more encapsulated network object, with some behaviour rather than just a holder of a collection of atomic routes.

There were a couple of other things to call out:
- you lacked unit tests where they could have helped document expected behaviour of objects
- a functional test asserting on the expected output, rather than just providing it would have been a bonus
- you documented using a design by contract tool that you didn't actually use

My feeling was that you correctly grasped the importance of understandability, and managed to emphasis readability to aid in that, but did not really have a good hold of how your program structure was impacting its complexity.