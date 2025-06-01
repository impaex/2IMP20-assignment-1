module labour::CST2AST

// This provides println which can be handy during debugging.
import IO;

// These provide useful functions such as toInt, keep those in mind.
import Prelude;
import String;
import ParseTree;

import labour::AST;
import labour::Syntax;

/*
 * Implement a mapping from concrete syntax trees (CSTs) to abstract syntax trees (ASTs)
 * Hint: Use switch to do case distinction with concrete patterns
 * Map regular CST arguments (e.g., *, +, ?) to lists
 * Map lexical nodes to Rascal primitive types (bool, int, str)
 */

// Main conversion function from parse tree to AST
public BoulderingWall cst2ast(start[BoulderingWall] parseTree) {
    return cst2ast(parseTree.top);
}

// Convert BoulderingWall
public BoulderingWall cst2ast((BoulderingWall)`bouldering_wall <WallId wallId> { volumes [ <Volume* volumes> ], routes [ <Route* routes> ] }`) {
    return boulderingWall(
        unquote("<wallId>"),
        [cst2ast(v) | v <- volumes],
        [cst2ast(r) | r <- routes]
    );
}

// Convert Volume types
public Volume cst2ast((Volume)`circle { pos <Position pos>, depth: <Integer depth>, radius: <Integer radius>, <HoldList? holdList> }`) {
    list[Hold] holds = [];
    if ((HoldList)`holds [ <Hold* hs> ]` := holdList) {
        holds = [cst2ast(h) | h <- hs];
    }
    return circle(cst2ast(pos), toInt("<depth>"), toInt("<radius>"), holds);
}

public Volume cst2ast((Volume)`rectangle { pos <Position pos>, depth: <Integer depth>, width: <Integer width>, height: <Integer height>. <HoldList? holdList> }`) {
    list[Hold] holds = [];
    if ((HoldList)`holds [ <Hold* hs> ]` := holdList) {
        holds = [cst2ast(h) | h <- hs];
    }
    return rectangle(cst2ast(pos), toInt("<depth>"), toInt("<width>"), toInt("<height>"), holds);
}

public Volume cst2ast((Volume)`rectangle { pos <Position pos>, depth: <Integer depth>, width: <Integer width>, height: <Integer height> <HoldList? holdList> }`) {
    list[Hold] holds = [];
    if ((HoldList)`holds [ <Hold* hs> ]` := holdList) {
        holds = [cst2ast(h) | h <- hs];
    }
    return rectangle(cst2ast(pos), toInt("<depth>"), toInt("<width>"), toInt("<height>"), holds);
}

public Volume cst2ast((Volume)`polygon { pos <Position pos>, faces [ <Face+ faces> ] }`) {
    return polygon(cst2ast(pos), [cst2ast(f) | f <- faces]);
}

// Convert Face
public Face cst2ast((Face)`face { vertices [ <Vertex+ vertices> ], <HoldList? holdList> }`) {
    list[Hold] holds = [];
    if ((HoldList)`holds [ <Hold* hs> ]` := holdList) {
        holds = [cst2ast(h) | h <- hs];
    }
    return face([cst2ast(v) | v <- vertices], holds);
}

public Face cst2ast((Face)`face { vertices [ <Vertex+ vertices> ] <HoldList? holdList> }`) {
    list[Hold] holds = [];
    if ((HoldList)`holds [ <Hold* hs> ]` := holdList) {
        holds = [cst2ast(h) | h <- hs];
    }
    return face([cst2ast(v) | v <- vertices], holds);
}

// Convert Vertex
public Vertex cst2ast((Vertex)`{ x: <Integer x>, y: <Integer y>, z: <Integer z> }`) {
    return vertex(toInt("<x>"), toInt("<y>"), toInt("<z>"));
}

// Convert Position
public Position cst2ast((Position)`{ x: <Integer x>, y: <Integer y> }`) {
    return position(toInt("<x>"), toInt("<y>"));
}

// Convert Hold
public Hold cst2ast((Hold)`hold <HoldId holdId> { pos <Position pos>, shape: <String shape>, rotation: <Integer rotation>, colours [ <Colour+ colours> ], <StartHold startHold> }`) {
    return hold(
        unquote("<holdId>"),
        cst2ast(pos),
        unquote("<shape>"),
        [cst2ast(c) | c <- colours],
        some(toInt("<rotation>")),
        some(cst2ast(startHold))
    );
}

public Hold cst2ast((Hold)`hold <HoldId holdId> { pos <Position pos>, shape: <String shape>, rotation: <Integer rotation>, colours [ <Colour+ colours> ], <EndHold endHold> }`) {
    return hold(
        unquote("<holdId>"),
        cst2ast(pos),
        unquote("<shape>"),
        [cst2ast(c) | c <- colours],
        some(toInt("<rotation>")),
        some(cst2ast(endHold))
    );
}

public Hold cst2ast((Hold)`hold <HoldId holdId> { pos <Position pos>, shape: <String shape>, rotation: <Integer rotation>, colours [ <Colour+ colours> ] }`) {
    return hold(
        unquote("<holdId>"),
        cst2ast(pos),
        unquote("<shape>"),
        [cst2ast(c) | c <- colours],
        some(toInt("<rotation>")),
        none()
    );
}

public Hold cst2ast((Hold)`hold <HoldId holdId> { pos <Position pos>, shape: <String shape>, colours [ <Colour+ colours> ], <StartHold startHold> }`) {
    return hold(
        unquote("<holdId>"),
        cst2ast(pos),
        unquote("<shape>"),
        [cst2ast(c) | c <- colours],
        none(),
        some(cst2ast(startHold))
    );
}

public Hold cst2ast((Hold)`hold <HoldId holdId> { pos <Position pos>, shape: <String shape>, colours [ <Colour+ colours> ], <EndHold endHold> }`) {
    return hold(
        unquote("<holdId>"),
        cst2ast(pos),
        unquote("<shape>"),
        [cst2ast(c) | c <- colours],
        none(),
        some(cst2ast(endHold))
    );
}

public Hold cst2ast((Hold)`hold <HoldId holdId> { pos <Position pos>, shape: <String shape>, colours [ <Colour+ colours> ] }`) {
    return hold(
        unquote("<holdId>"),
        cst2ast(pos),
        unquote("<shape>"),
        [cst2ast(c) | c <- colours],
        none(),
        none()
    );
}

// Convert StartHold and EndHold
public HoldType cst2ast((StartHold)`start_hold: <Integer number>`) {
    return startHold(toInt("<number>"));
}

public HoldType cst2ast((EndHold)`end_hold`) {
    return endHold();
}

// Convert Route
public Route cst2ast((Route)`bouldering_route <RouteId routeId> { grade: <String grade>, grid_base_point <Position gridBasePoint>, holds [ <String* holdIds> ] }`) {
    return boulderingRoute(
        unquote("<routeId>"),
        unquote("<grade>"),
        cst2ast(gridBasePoint),
        [unquote("<holdId>") | holdId <- holdIds]
    );
}

// Convert Colour
public Colour cst2ast((Colour)`white`) = white();
public Colour cst2ast((Colour)`yellow`) = yellow();
public Colour cst2ast((Colour)`green`) = green();
public Colour cst2ast((Colour)`blue`) = blue();
public Colour cst2ast((Colour)`red`) = red();
public Colour cst2ast((Colour)`purple`) = purple();
public Colour cst2ast((Colour)`pink`) = pink();
public Colour cst2ast((Colour)`black`) = black();
public Colour cst2ast((Colour)`orange`) = orange();

// Helper function to remove quotes from strings
private str unquote(str s) {
    if (startsWith(s, "\"") && endsWith(s, "\"")) {
        return substring(s, 1, size(s) - 1);
    }
    return s;
}