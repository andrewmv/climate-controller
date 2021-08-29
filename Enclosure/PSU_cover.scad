include <PSU.scad>

difference() {
    translate([0,0,-1])
        cube(size=[xdim+(2*wt),ydim+(2*wt),2]);
    psu_case();
    translate([wt+.5,0,0])
        cube(size=[xdim-1,ydim+.5,1]);
}