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

Lightweight architecture decision records in doc/arch