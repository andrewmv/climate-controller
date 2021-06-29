tol = 0.25;
xdigit=11.012;
ydigit=14.221;
xdim=25 + tol;
ydim=19.05 + tol;
zdim=1;
diffuse_thickness=0.25;
inter_digit=12.7;
xoff1 = 1;
xoff2 = xoff1 + inter_digit;
yoff = 2.5;
ridge_thickness = 1;
ridge_height = 1;

printer_layer_height=0.1313;

*difference() {
	translate([-ridge_thickness, -ridge_thickness, 0]) {
		cube(size=[xdim + (2 * ridge_thickness),
				   ydim + (2 * ridge_thickness),
				   zdim + ridge_height]);
	}
	cube(size=[xdim, ydim, zdim + ridge_height + 1]);
}

for(i = [2:1:6]) {
	translate([0, (ydim + 1) * (i - 2), 0]) {
		mirror([1,0,0]) {
			mod1(printer_layer_height * i);
		}
		translate([0, 0, 0]) {
			difference() {
				cube(size=[10, ydim, zdim]);
				removal_tab();
				translate([9,2,-1]) {
					mirror([1,0,0]) {
					linear_extrude(zdim + 2)
						text(str(i), 10);
					}
				}
			}
		}
	}
}

// number stencil bits
translate([0, (ydim + 1) * (4 - 2) + 6, 0]) 
	cube(size=[10, 1, zdim]);
translate([0, (ydim + 1) * (6 - 2) + 4.5, 0]) 
	cube(size=[10, 1, zdim]);

module removal_tab() {
	translate([10-2,ydim - 4, 0])
		rotate([0,45,0])
			cube(size=[2,4,4]);
}

// !color("red")	removal_tab();

// homing overlay
module mod1(d) {
	difference() {
		cube(size=[xdim, ydim, zdim]);
		translate([xoff1 + (tol/2),yoff + (tol/2),d])
			digit_channels(zdim);
		translate([xoff2 + (tol/2),yoff + (tol/2),d])
			digit_channels(zdim);
	}
}

module digit_channels(h) {
	linear_extrude(height=h, center=false, convexity=6) {
		import(file="7-segment_layout_scaled_90.svg", layer="layer2", dpi=96);
	}
}

