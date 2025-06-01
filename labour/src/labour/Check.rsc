module labour::Check

import labour::AST;
import labour::Parser;
import labour::CST2AST;

import IO;
import List;
import Set;
import Prelude;
import String;


/*
 * Implement a well-formedness checker for the LaBouR language. For this you must use the AST.
 * - Hint: Map regular CST arguments (e.g., *, +, ?) to lists
 * - Hint: Map lexical nodes to Rascal primitive types (bool, int, str)
 * - Hint: Use switch to do case distinction with concrete patterns
 */

/*
 * Define a function per each verification defined in the PDF (Section 2.2.)
 * Some examples are provided below.
 */

bool checkBoulderWallConfiguration(BoulderingWall wall){
  bool numberOfHolds = checkNumberOfHolds(wall);

  bool startingLabelLimit = checkStartingHoldsTotalLimit(wall);
  bool unique_end_hold = checkUniqueEndHold(wall);

  return (numberOfHolds && startingLabelLimit && unique_end_hold);
}


// Check that there are at least two holds in the wall
bool checkNumberOfHolds(BoulderingWall wall) {
  // Collect all holds from the wall
  Set[Hold] holds = {};
  for (Route route <- wall.routes) {
    holds += route.holds;
  }
  // Check if the number of holds is at least two
  if (size(holds) < 2) {
    println("Error: The wall must have at least two holds.");
    return false;
  }
  return true;
}

// Check that routes have between zero and two hand start holds
bool checkStartingHoldsTotalLimit(BoulderingWall wall) {
  for (Route route <- wall.routes) {
    int handStartCount = 0;
    for (Hold hold <- route.holds) {
      if (hold.type == "hand_start") {
        handStartCount++;
      }
    }
    if (handStartCount > 2) {
      println("Error: Route " + route.name + " has more than two hand start holds.");
      return false;
    }
  }
  return true;
}

// This function will insure that there is only one hold assign to end hold
bool checkUniqueEndHold(BoulderingWall wall){
  Set[Hold] endHolds = {};
  for (Route route <- wall.routes) {
    for (Hold hold <- route.holds) {
      if (hold.type == "end") {
        endHolds += hold;
      }
    }
  }
  if (size(endHolds) != 1) {
    println("Error: There must be exactly one end hold on the wall.");
    return false;
  }
  Hold endHold = first(endHolds);
  // Check if the end hold is not a hand start hold
  if (endHold.type == "hand_start") {
    println("Error: The end hold cannot be a hand start hold.");
    return false;
  }
  return true;
}
