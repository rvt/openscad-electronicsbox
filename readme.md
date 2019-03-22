use <MCAD/boxes.scad>

### OpenSCAD Electronics box where the screws are put at the bottom
Should beable to get it 3D printed without isues.
//
### License: License MIT

## Usage 1:

```
// Make abox with the following specifications:
// Length: 125
// Width:  80
// Depth: 30
// Wall Thickness:  2.4
// Screw Diameter:  3
// Screw Head Size: 6
use <MCAD/boxes.scad>
include <electronicsbox.escad>

electronics_box_method = "openscad";

$fn=50;
box(125, 80, 30, 2.4, 3, 6);
```
![Electronics Box](images/box_inside.jpg "Electronics Box")

## Usage 2:
```
// Create a box where top and bottom are of different dimentions
// Length: 125
// Width:  80
// Depth: 17 ( of each single side)
// Wall Thickness:  2.4
// Screw Diameter:  4
// Screw Head Size: 8
// Fixture location of wall size: 6
// rim depth: 0.75
use <MCAD/boxes.scad>
include <electronicsbox.escad>

electronics_box_method = "openscad";

$fn=50;
box_top   (125, 80, 17, 2.4, 4, 8, 6, 0.75);
box_bottom(125, 80, 14, 2.4, 4, 8, 6, 0.75);
```


## Implicicad

Experimental: You can try your luck with implicitcad.

Note: On a personal note, I found implicitcad more tricky to get good results.

```
extopenscad -r 0.5 electronicsbox.escad -f stl -o electronicsbox.stl
```

## ImplicitCAD vs OpenSCAD

I did a quick comparison between ImplicitCAD and OpenSCAD to see how both system would render the electronics box.
I need to check with the implicitCAD community to understand if I messed up or mis-undersootd the render settings
as at this moment the output has some clear artifacts.

### Render settings
ImplicitCAD rendered with r = 0.5

OpenSCAD rendered with $fn=36

### STL File Sizes:
OpenSCAD 1.1MB

ImplicitCAD: 29.4MB


![Electronics Box ImplicitCAD](images/implicitcad-r0.5.jpg "Electronics Box")
![Electronics Box OpenSCAD](images/openscad-$fn=36.jpg "Electronics Box")
