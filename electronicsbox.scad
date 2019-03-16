use <MCAD/boxes.scad>

// OpenSCAD Electronics box where the screws are put at the bottom
// Should beable to get it 3D printed without isues.
//
// License MIT
// 
// Usage 1:
//
// Make abox with the following specifications:
// Length: 125
// Width:  80
// Depth: 30
// Wall Thickness:  2.4
// Screw Diameter:  3
// Screw Head Size: 6
// box(125, 80, 30, 2.4, 3, 6);
//
// Usage 2:
//
// Create a box where top and bottom are of different dimentions
// Length: 125
// Width:  80
// Depth: 17 ( of each single side)
// Wall Thickness:  2.4
// Screw Diameter:  4
// Screw Head Size: 8
// Fixture location of wall size: 6
// rim depth: 0.75
// box_top   (125, 80, 17, 2.4, 4, 8, 6, 0.75);
// box_bottom(125, 80, 14, 2.4, 4, 8, 6, 0.75);
// $fn=50;

box(125, 80, 30, 2.4, 3, 6);

module box(length, width, depth, thickness, screwDiam, screwHeadDiam) {
    fixtureLocation = screwHeadDiam*1.5;
    translate([-length/2,2.5,0]) {
        box_top(length, width, depth/2, thickness, screwDiam, screwHeadDiam, screwHeadDiam, 0.75);
        translate([0,-width-5,0]) {
            box_bottom(length, width, depth/2, thickness, screwDiam, screwHeadDiam, screwHeadDiam, 0.75);
        };
    };
}

module box_top(length, width, depth, thickness, screwDiam, screwHeadDiam, fixtureLocation, rimDepth) {
    corners = [
        [0,0,180],
        [0,width,90],
        [length,0,270],
        [length,width,0],
    ];

    translate([0, 0, depth]) {
        // Basic box layout
        box_basic(length, width, depth, thickness);
        // Render corners
        render_corners(corners, depth - thickness, screwDiam, screwHeadDiam, fixtureLocation, "fixture_top");
        box_center_edge(length, width, depth, rimDepth, thickness);

    };
}  

module box_bottom(length, width, depth, thickness, screwDiam, screwHeadDiam, fixtureLocation, rimDepth) {
    corners = [
        [0,0,180],
        [0,width,90],
        [length,0,270],
        [length,width,0],
    ];

    translate([0, 0, depth]) {
        difference() {
            difference() {
                translate() {            
                    // Basic box layout
                    box_basic(length, width, depth, thickness);
                    // Render corners
                    render_corners(corners, depth - thickness, screwDiam, screwHeadDiam, fixtureLocation, "fixture_bottom");
                };
                // Remove screw head
                translate([0,0,-thickness-0.1]) {
                    render_corners(corners, depth - thickness, screwDiam, screwHeadDiam, fixtureLocation, "head_bottom_hole");
                };

            };
            box_center_edge(length, width, depth-rimDepth, rimDepth, thickness);

        };
    };
}  

// Basic box 
// length: length of box
// width: Width of the box
// depth: Depth of the box
// thickness: Wall thickness of the box
module box_basic(length, width, depth, thickness) {
        translate([length/2,width/2,-depth/2]) {
            // Render sides
            difference() {
                roundedBox([length, width, depth], 1, true);
                roundedBox([length-thickness*2, width-thickness*2, depth*1.1], 1, true);
            }
            // Render bottom part box
            translate([0,0,-depth/2 + thickness/2 ]) {
                roundedBox([length-0, width, thickness], 1, true);
            }
        }
};

module box_center_edge(length, width, depth, depthEdge, thickness) {
    t = thickness / 3;
    translate([length/2,width/2,0]) {
        difference() {
            roundedBox([length-t*2, width-t*2, depthEdge], 1, true);
            roundedBox([length-thickness*2+t*2, width-thickness*2+t*2, depthEdge*2], 1, true);
        }
    }
};

// Render the corners of the box
// Corners array
// depth: Depth of the support
// screwDiam: Diameter of the original screw so we can calculate placement
// screwHeadDiam: Diameter of the screw head
// fixtureLocation: to where we want to support to extend (usually where the wall is)
// what: to render
module render_corners(corners, depth, screwDiam, screwHeadDiam, fixtureLocation, what) {
    for (corner = corners) {
        translate([corner[0], corner[1], 0]) {
            rotate(a = [0, 0, corner[2]]) { 
                translate([-fixtureLocation, -fixtureLocation, -depth]) {
                    if (what == "fixture_top") {
                        screw_fixture_top(depth, screwDiam, fixtureLocation);
                    }
                    if (what == "fixture_bottom") {
                        screw_fixture_bottom(depth, screwDiam, screwHeadDiam, fixtureLocation);
                    }
                    if (what == "head_bottom_hole") {
                        screw_head_bottom_hole(depth, screwDiam, screwHeadDiam, fixtureLocation);
                    }
                }
            }
        }
    }
}

// Calculate the amouth of support around screw hole
function holeMaterialSize(p) = p*1.5;

// Create a screw hole 
// depth: Depth of the support
// diameter: Diameter of the original screw so we can calculate placement
// supportExtend to where we want to support to extend (usually where the wall is)
module screw_fixture_top(depth, diameter, supportExtend) {
    materialSize = holeMaterialSize(diameter);
        
    difference() {
        difference() {
            cylinder(h=depth, d=materialSize);
            translate([0, 0, -2]) {
                rotate(a = [0, 50, 45]) { 
                    cube([20, materialSize, materialSize], center=true);
                }
            }
        }
        cylinder(h=depth*4, d=diameter*0.85,center=true);
    }
    screw_fixture_support(depth, diameter, supportExtend);
}


// Render bottom part of the screw fixture
module screw_fixture_bottom(depth, diameter, screwHeadDiam, supportExtend) {
    materialSize = holeMaterialSize(diameter);
        
    difference() {
        translate() {
            cylinder(h=depth, d=materialSize);
            cylinder(h=diameter, d=screwHeadDiam+1);
            translate([0,0,diameter]) {
                cylinder(h=screwHeadDiam/2, d1=screwHeadDiam+1, d2=diameter);
            };
        }
        cylinder(h=depth*4, d=diameter+0.25,center=true);
    }
    screw_fixture_support(depth, diameter, supportExtend);
}

// Renders bottom how where the screw head will fit
module screw_head_bottom_hole(depth, diameter, screwHeadDiam, supportExtend) {
    cylinder(h=diameter+1, d=screwHeadDiam);
}

// Build a fixture attachement.
// This can be used if the fixture is away from teh walls you
// can create 
// depth: Depth of the support
// diameter: Diameter of the original screw so we can calculate placement
// supportExtend to where we want to support to extend (usually where the wall is)
module screw_fixture_support(depth, diameter, supportExtend) {
    attachmentWidth = 2;
    if (supportExtend>diameter/2) {
        translate([diameter/2, -attachmentWidth/2, -0]) {
            cube([supportExtend - diameter/2, attachmentWidth, depth]);
        }
        translate([-attachmentWidth/2, diameter/2, 0]) {
            cube([attachmentWidth, supportExtend - diameter/2, depth]);
        }        
    }
}    
