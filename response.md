# Response to comments

## There were several things i really liked about your code: a working solution, readability of function names, applying method extraction refactorings and evidence of some small-step TDD. The honest comments and design records also helped me understand your thinking.

Thank you for the kind words.

I would add that the total variable span and live time is small.

## Encapsulation was weak, e.g. leading to coupling of permutations code into internals of route extension (look for law of demeter violations)

### Overview

I think the statement "Encapsulation was weak" overstates the case.

I have never come across a programmer that applies the Law of Demeter absolutely. I believe that the general wisdom is to weigh up the benefits of the encapsulation against the additional pass through code that is required. I notice that Martin Fowler would prefer it to be called the "Occasionally Useful Suggestion of Demeter"

There are plenty of cases of good encapsulation in the original submission, and only a small number of cases of debatable encapsulation.

I have looked at the code to look for opportunities to meaningfully increase encapsulation, and have done the following:
- Added RouteCandidate.starting_point
- Added RouteCandidate.ending_point

### Specific Cases

I think you are probably talking about these lines of code when you talk about the Law of Demeter violations from "permutations code into internals of route extension".

#### Line 91: route_extension.route_candidate.distance

This does violate the Law of Demeter and could be changed to route_extension.route_candidate_distance. 

This would allow RouteExtension to change the way that the distance is calculated for the RouteCandidate without affecting the public interface.

One reason not to do this is that this is a very unlikely scenairo.

However, the most important reason is that the RoutePermutations class is already coupled to RouteCandidate.distance and RouteExtension is already coupled to RouteCandidate. This means that from the point of the RoutePermutations class, RouteExtension cannot swap the RouteCandidate class for something else, and that RouteCandidate.distance cannot be removed without breaking the encapsulation. 

Implementing route_candidate_distance would allow RouteExtension to implement caching or something similar, but there is no need to do this as the call is so simple. RouteCandidate.distance is more complicated, and could potentially benefit from caching or a change in the algorithm, and this is already encapsulated in the original design.

Overall, I don't see any meaningful increase in encapsulation by making this change.

#### Line 95: route_extension.atomic_routes.count

I don't consider this to be a meaningful violation. atomic_routes is an array property on the public interface and count is a language feature, so I don't think there would be any benefit to changing it to route_extension.atomic_routes_count.

### RouteExtension and RouteCandidate felt like both being routes that were used in slightly different contexts

This is an interesting point, and I had a think about it, but in the end I disagree for the following reasons.

- The retraces_existing_leg method is a good fit in RouteExtension but does not make as much sense in RouteCandidate. 
- RouteExtension has a specific initialise method, and I prefer to only have one constructor for each class where possible.
- RouteExtension.route_candidate encapsulates a useful bit of logic that would not be easily possible if the class didn't exist.
- There is no overlap in the methods of the two classes

## Really RoutePermutations was doing most (too much) of the work itself

I have introduced a new RouteExtensions class, which removes a lot of code from RoutePermutations, and probably more importantly improves the readability of the code.

## Simple use of instance data, e.g. for the invariant route topology used in route permutations, could have reduced a lot of code

I have made network_topology an instance variable of RoutePermutations. I'm not sure what I was thinking there. The phrase "could have reduecd a lot of code" is a heavy exaggeration though.

## AtomicRoute was awkward naming. a route being composed of atomic routes? would have preferred a route composed of legs or tracks. admittedly, the trains problem is a bit loose with the word 'route' but i found this distracting.

I mostly disagree with this. 

"Atomic" has a well defined meaning that is used elsewhere in computing so should be known by all programmers, and "Route" is in the language of the domain. It is however a bit long and clunky.

"Leg" is short, but does not have a well defined meaning and may not be understandable by all programmers, especially in a globally distributed team, and it is not in the domain.

"Track" is short, and is in the language of the domain, but the domain definition is not well defined.

I have however, changed AtomicRoute to Leg. 

If I were to do this in the real world I would want to introduce Leg to the domain.

## RouteExtension.atomic_routes was awkward naming - it was actually atomic routes without/before extension (or legs without last)

atomic_routes was an array of AtomicRoute, so I would argue that the variable was well named. I think you consider that an array of AtomicRoute is the same thing as a RouteCandidate, but they are distinct concepts.

However, I have renamed this to original_legs.

## RouteExtension.atomic_route was awkward naming - it was actually the extending/last atomic route

I would argue that the variable name should be taken in context with the class name, in which case it makes more sense.

However, I have renamed this to extension_leg.

## NetworkTopology was really a NetworkTopologyParser. Again, could have been a stronger, more encapsulated network object, with some behaviour rather than just a holder of a collection of atomic routes.

I have added NetworkTopologyParser, which returns a NetworkTopology.

I can't think of any more behaviour that I would want to put in the NetworkTopology class, or any ways to make it a stronger, more encapsulated object. 

RoutePermutations.initial_route_candidates_starting_at_from and RouteExtensions.legs_that_extend_route_candidate could be added to NetworkTopologyParser, but I think they are better were they are. 

There were no meaningful encapsulation issues.

## You lacked unit tests where they could have helped document expected behaviour of objects

This is definitely a good idea, I have added expected behaviour tests for Leg, RouteCandidate and RouteExtension.

I had considered it out of scope for a task that it is possible to complete in 2 hours.

I haven't added expected behaviour tests for RouteExtensions, due to time constraints. If you need to know that I am able to write these tests, then please let me know and I will do them.

I wrote this code using TDD, so all the code (except a couple of 'to_s' methods that I cheated on) was already covered.

I don't think you learn anything more about my programming ability from these tests, and they do take a noticeable amount of time to write. I would suggest that you could make this assignment less time consuming, and no less informative, by removing the requirement for them.

## A functional test asserting on the expected output, rather than just providing it would have been a bonus

This is definitely a good idea, I have added fuctional tests. I had considered it out of scope for a task that it is possible to complete in 2 hours.

I don't think you learn anything more about my programming ability from these tests, and they do take a noticeable amount of time to write. I would suggest that you could make this assignment less time consuming, and no less informative, by removing the requirement for them.
