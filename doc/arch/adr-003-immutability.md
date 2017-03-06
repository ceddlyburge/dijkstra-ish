# Context

Shared mutable state is the source of a lot of bugs.

# Decision

We will return immutable objects from methods.

# Status

Accepted.

# Consequences

The code will need to be refactored to implement this.

Some code will be harder to write.

The code will be easier to reason about.

The code may have less bugs.

Memory consumption may increase as more copies of objects are used.

