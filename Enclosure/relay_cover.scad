include <climate_enclosure.h>

// ASSEMBLY

translate([0,0,-relay_cover_height - mounting_hole_depth - relay_dim.z]) {
	translate([-jbox_dim.x/2,0,0]) {
		translate(relay_pos) {
			if (render_supports) {

			} else {
				relay_asm();
			}
		}
	}
}

module relay_asm() {
	difference() {
		sides();
		mount_stem_negatives();
		rc_label();
		conn_cuts();
	}
	difference() {
		mount_stems();
		relay_outline();
	}
	// rc_label();
}

// MODULES

module conn_cuts() {
	for (i = [0:len(relay_conn_openings)-1]) {
		translate([	relay_dim.x - relay_cover_thickness,
					relay_conn_openings[i][0],
					relay_cover_height - relay_conn_height])
		color("grey") {
			cube(size=[	relay_cover_thickness,
						relay_conn_openings[i][1],
						relay_conn_height]);
		}
	}
}

module rc_label() {
	translate([0.5,10,relay_cover_height - label_size - 1])
	rotate([90,0,90]) {
		color("red") {
			linear_extrude(1) {
				text(label_text, label_size);
			}
		}
	}
}

module mount_stems() {
	intersection() {
		for (i = [0:len(relay_mounting_holes)-1]) {
			translate(relay_mounting_holes[i]) {
				if (relay_mounting_holes[i][x] > relay_dim.x / 2) {
					mount_stem_right();
				} else {
					mount_stem_left();
				}
			}
		}
		cube(size=[relay_dim.x,relay_dim.y,relay_cover_height]);
	}
}

module mount_stem_negatives() {
	for (i = [0:len(relay_mounting_holes)-1]) {
		translate(relay_mounting_holes[i]) {
			if (relay_mounting_holes[i][x] > relay_dim.x / 2) {
				mount_stem_filled();
			} else {
				mirror([1,0,0])
					mount_stem_filled();
			}
		}
	}
}

module mount_stem_right() {
	difference() {
		mount_stem_filled();
		translate([0,0,-relay_cover_thickness]) {
			linear_extrude(relay_cover_height) {
				circle(r=relay_cover_mount_stem_r - relay_cover_thickness);
				translate([0,-relay_cover_mount_stem_r + relay_cover_thickness,0]) {
					square(size=[11, 2 * (relay_cover_mount_stem_r - relay_cover_thickness)]);
				}
			}
		}
		linear_extrude(relay_cover_height + 1)
			circle(r=relay_cover_mount_hole_r);
	}	
}

module mount_stem_left() {
	mirror([1,0,0])
		mount_stem_right();
}

module mount_stem_filled() {
	linear_extrude(relay_cover_height) {
		circle(r=relay_cover_mount_stem_r);
		translate([0,-relay_cover_mount_stem_r]) {
			square(size=[10, 2 * relay_cover_mount_stem_r]);
		}
	}
}

module sides() {
	difference() {
		cube(size=[	relay_dim.x,
					relay_dim.y,
					relay_cover_height]);
		translate([	relay_cover_thickness,
					relay_cover_thickness,
					relay_cover_thickness]) {
				cube(size=[	relay_dim.x - (2 * relay_cover_thickness),
							relay_dim.y - (2 * relay_cover_thickness),
							relay_cover_height + 2]);
		}
		relay_outline();
	}
}

module relay_outline() {
	translate([0,0,-1]) {
		linear_extrude(height=relay_cover_height+2, center=false, convexity=4) {
			translate([relay_dim.x,0,0]) {
				mirror([1,0,0]) {
					import(file="relay_outline.svg", layer="layer1", dpi=96);
				}
			}
		}
	}
}