module labour::Syntax

/*
 * Define a concrete syntax for LaBouR. The language's specification is available in the PDF (Section 2)
 */

/*
 * Note, the Server expects the language base to be called BoulderingWall.
 * You are free to change this name, but if you do so, make sure to change everywhere else to make sure the
 * plugin works accordingly.
 */
start syntax BoulderingWall
 = "bouldering_wall" WallId "{" "volumnes" "[" Volume* "]" "," "routes" "[" Route* "]" "}" ;
 
syntax WallId = wallId: String;

syntax Volume = Circle | Rectangle | Polygon;

syntax Circle = "circle" "{" "pos" Position "," "depth" ":" Integer "," "radius" ":" Integer ","? HoldList? "}";

syntax Rectangle = "rectangle" "{" "pos" Position "," "depth" ":" Integer "," "width" ":" Integer "," "height" ":" Integer ","? HoldList? "}";

syntax Polygon = "polygon" "{" "pos" Position "," "faces" "[" Face+ "]" "}";

// Face definition of polygons
syntax Face = "face" "{" "vertices" "[" Vertex+ "]" ","? HoldList? "}";

syntax Vertex = "vertex" "{" "x" ":" Integer "," "y" ":" Integer "," "z" ":" Integer "}";

syntax Position = "{" "x" ":" Integer "," "y" ":" Integer "}";

syntax HoldList = "holds" "[" Hold* "]";

// Hold definition
syntax Hold = "hold" HoldId "{" "pos" Position "," "shape" ":" String "," ("rotation" ":" Integer ",")? "colours" "[" Colour+ "]" ","? (StartHold | EndHold)? "}";

syntax HoldId = holdId: String;

// Route definition
syntax Route = "bouldering_route" RouteId "{" "grade" ":" String "," "grid_base_point" Position "," "holds" "[" HoldId* "]" "}";

syntax RouteId = routeId: String;

// Start and end holds for routes
syntax StartHold = "start_hold" ":" Integer;
syntax EndHold = "end_hold";

// Colour definition
syntax Colour = "white" | "yellow" | "green" | "blue" | "red" | "purple" | "pink" | "black" | "orange";

// String literals
syntax String = string: "\"" StringChar* "\"";
syntax StringChar = ![\"\\] | [\\][\"\\nrtfb];

// Integer literals
syntax Integer = integer: [0-9]+ | "-" [0-9]+;

// Layout and whitespace handling
layout Layout = LayoutChar* !>> LayoutChar;
lexical LayoutChar = [\t\n\r\f];