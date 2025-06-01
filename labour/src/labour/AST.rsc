module labour::AST

/*
 * Define the Abstract Syntax for LaBouR
 * - Hint: make sure there is an almost one-to-one correspondence with the grammar in Syntax.rsc
 */

data BoulderingWall(loc src=|unknown:///|)
  = BoulderingWall(str wallId, list[Volume] volumes, list[Route] routes)
  ;

// Volume types
data Volume = circle(Position pos, int depth, int radius, list[Hold] holds)
            | rectangle(Position pos, int depth, int width, int height, list[Hold] holds)
            | polygon(Position pos, list[Face] faces);

// Face definition for polygons
data Face = face(list[Vertex] vertices, list[Hold] holds);

// Vertex with 3D coordinates
data Vertex = vertex(int x, int y, int z);

// Position with 2D coordinates
data Position = position(int x, int y);

// Hold definition
data Hold = hold(str holdId, Position pos, str shape, list[Colour] colours, 
                 Maybe[int] rotation, Maybe[HoldType] holdType);

// Hold types (start or end)
data HoldType = startHold(int number) | endHold();

// Route definition
data Route = boulderingRoute(str routeId, str grade, Position gridBasePoint, list[str] holdIds);

// Colour enumeration
data Colour = white() | yellow() | green() | blue() | red() | purple() | pink() | black() | orange();

// Maybe type for optional values
data Maybe[&T] = none() | some(&T val);