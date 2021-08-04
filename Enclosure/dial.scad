include <climate_enclosure.h>

//*** ASSEMBLY ***//

translate(face_pos)
translate([0,pcb_pos.y + dial_pos.y + yoff, dial_depth + brim_thickness])
	rotate([180,0,0])
		dial_asm();

module dial_asm() {
	difference() {
		dial_solid();
		dial_hollow();
	}
	dial_shaft();
}

//*** MODULES ***//

module dial_shaft() {
	difference() {
		translate([0,0,dial_walls]) {
			linear_extrude(dial_shaft_depth) {
				circle(r=dial_shaft_r);
			}
		}
		linear_extrude(dial_shaft_depth + dial_walls + 1) {
			difference() {
				circle(r=dial_hole_r);
				translate([-dial_hole_r,dial_hole_r - dial_hole_cut,0]) {
					square(dial_shaft_r * 2);
				}
			}
		}
	}
}

module dial_hollow() {
	factor = 1 - (dial_walls / dial_r);
	translate([0,0,dial_walls]) {
		scale([factor,factor,1]) {
			dial_solid();
		}
	}
}

module dial_solid() {
	dial_base();
	dial_bezel();
	dial_face();
}

module dial_face() {
	linear_extrude(dial_bezel_r) {
		circle(r=dial_r - dial_bezel_r);
	}
}

module dial_base() {
	translate([0,0,dial_bezel_r]) {
		linear_extrude(dial_depth) {
			circle(r=dial_r);
		}
	}
}

module dial_bezel() {
	translate([0,0,dial_bezel_r]) {
		rotate_extrude(angle=360, convexity=4) {
			translate([dial_r - dial_bezel_r,0,dial_bezel_r]) {
				circle(dial_bezel_r);
			}
		}
	}
}