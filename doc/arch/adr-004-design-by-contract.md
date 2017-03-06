# Context

Input values need to be checked for validity.

# Decision

We will check input values immediately after they are received and return error messages if there are problems.

Downstream of this we assume that all input values are correct, and we will raise exceptions if this is not the case. We will use [contracts.ruby](https://github.com/egonSchiele/contracts.ruby) to do this.

# Status

Accepted.

# Consequences

The code will need to be refactored to implement this.

There will be a small decrease in performance.

The code will document its requirements.

The code will document is deliverables.

The code will be easier to reason about.

Bugs will be caught nearer to their cause.

