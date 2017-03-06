# Context

Code can be optimised for speed, for memory consumption or readability.

# Decision

We will optimise for readability, unless the results take longer than a second to return, at which point we will make speed optimisations target at hot spots identified by a profiler.

# Status

Accepted.

# Consequences

Optimising for readability makes the code easier to maintain and debug

Optimising for readability means that targeted refactoring may be needed to meet speed and or memory requirements in the future. 
