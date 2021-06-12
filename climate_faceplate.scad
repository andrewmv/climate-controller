//*** DIMENSIONS ***//
x = 0; y = 1; z = 2;	// simplify array references
printer_layer_height=0.1313;
tol = 0.25;				// tolerance
$fn = 20;				// facet count for curves

dial_pos = [23.63,19.52];
dial_r = 18;
thickness = 3;
corner_r = 10;
brim_thickness = 5;
display_thickness = 8; 
display_window_layers = 3;
display_window_thickness = display_window_layers * printer_layer_height;
display_window_depth = 1;
display_pos = [[10.93,39.44],[10.93,59.76]];
display_dim = [25.4,19,display_thickness];
xdim = 75; //placeholder
ydim = 120;
zdim = display_thickness + display_window_depth;
pcb_dim = [54.8,82.29,1.6];
pcb_pos = [
	(xdim / 2) - dial_pos.x,
	(ydim / 2) - (pcb_dim.y / 2),
	zdim
];
diffuse_inter_digit=12.7;
diffuse_xoff1 = 1;
diffuse_xoff2 = diffuse_xoff1 + diffuse_inter_digit;
diffuse_yoff = 2.5;

mounting_holes = [
	[3.81,5.08],
	[51.01,5.08],
	[3.81,78.81],
	[51.01,78.81]
];
mounting_stem_r = 6;	
mounting_hole_r = 2.5;		//for T6 screws
mounting_hole_depth = 8;	//for 6mm screws
mounting_stem_support_height = zdim;
mounting_stem_support_base = zdim;
mounting_stem_support_thickness = 2;

//*** ASSEMBLY ***//

mirror([1,0,0])	asm();

module asm() {
	difference() {
		faceplate();
		dial();
		display_well();
		for(i = [0:len(mounting_holes)-1]) {
			translate(pcb_pos + mounting_holes[i]) {
				linear_extrude(zdim) {
					circle(mounting_stem_r);
				}
			}
		}
	}
	display_channels();
	brim();

	for(i = [0:len(mounting_holes)-1]) {
		difference() {
			translate(pcb_pos + mounting_holes[i]) {
				mounting_stem();
			}
			display_well();
		}
	}

	// placeholder PCB - do not print
	*translate(pcb_pos)
		color("green")	cube(size=pcb_dim);
}

//*** MODULES ***//

module faceplate() {
	cube(size=[xdim, ydim, thickness]);
}

module brim() {
	difference() {
		cube(size=[xdim, ydim, brim_thickness]);
		translate([thickness, thickness, -1]) {
			cube(size=[xdim - (2 * thickness),
					   ydim - (2 * thickness),
					   brim_thickness + 2]);
		}
	}
}

module dial() {
	translate([pcb_pos.x + dial_pos.x, pcb_pos.y + dial_pos.y, -1]) {
		linear_extrude(zdim + 2) {
			circle(dial_r);
		}
	}
}

module display_well() {
	for (i = [0:len(display_pos)-1]) {
		translate([pcb_pos.x + display_pos[i][x],
				   pcb_pos.y + display_pos[i][y],
				   -1]) {
			cube(size=display_dim);
		}
	}
}

module display_channels() {
	for (i = [0:len(display_pos)-1]) {
		translate(pcb_pos + display_pos[i]) {
			difference() {
				cube(size=[display_dim.x,
						   display_dim.y,
						   display_window_depth]);;
				translate([diffuse_xoff1 + (tol/2),
						   diffuse_yoff + (tol/2),
						   display_window_thickness])
					digit_channels(display_dim.z);
				translate([diffuse_xoff2 + (tol/2),
						   diffuse_yoff + (tol/2),
						   display_window_thickness])
					digit_channels(display_dim.z);
			}
		}
	}
}

module digit_channels(h) {
	linear_extrude(height=h, center=false, convexity=6) {
		import(file="7-segment_layout_scaled_90.svg", layer="layer2", dpi=96);
	}
}

module mounting_stem() {
	difference() {
		linear_extrude(zdim) {
			circle(mounting_stem_r);
		}
		translate([0,0,zdim - mounting_hole_depth]) {
			linear_extrude(mounting_hole_depth + 1) {
				circle(mounting_hole_r);
			}
		}
	}
	// stem_support(0);
	// stem_support(90);
	// stem_support(180);
	// stem_support(270);
}

//support triangle
support_points = [
	[0,0],
	[0, mounting_stem_support_height],
	[mounting_stem_support_base, 0]
];
support_paths = [[0, 1, 2]];

module stem_support(rotation) {
	rotate([90,0,rotation]) {
		translate([mounting_stem_r - 1,0,-mounting_stem_support_thickness / 2]) {
			linear_extrude(mounting_stem_support_thickness) {
				polygon(points=support_points, paths=support_paths);
			}
		}
	}
}