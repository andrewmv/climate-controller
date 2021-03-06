include <climate_enclosure.h>

// ASSEMBLY

translate([0,0,-relay_cover_height]) {
	translate([jbox_dim.x/2,0,0]) {
		rotate([0,0,180]) {
			translate([relay_pos.x, -relay_pos.y - relay_dim.y, relay_pos.z]) {
				if (render_supports) {

				} else {
					relay_asm();
				}
			}
		}
	}
}

module relay_asm() {
	difference() {
		sides();
		mount_stem_negatives();
		rc_label();
	}
	difference() {
		mount_stems();
		relay_outline();
	}
	relay_front_cover();
}

// MODULES

module relay_front_cover() {
	translate([	0,
				relay_dim.y,
				relay_cover_height - relay_pcb_inset]) {
		cube(size=[relay_dim.x,relay_cover_thickness,relay_pcb_inset]);
	}
}

module rc_label() {
	translate([-0.5,10,relay_cover_height - label_size - 1])
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
		union() {
			for (i = [0:len(relay_mounting_holes)-1]) {
				translate(relay_mounting_holes[i]) {
					if (relay_mounting_holes[i][x] > relay_dim.x / 2) {
						mount_stem_right();
					} else {
						mount_stem_left();
					}
				}
			}
			for (i = [0:len(relay_actap_pos)-1]) {
				translate(relay_actap_pos[i]) {
					if (relay_actap_pos[i][x] > relay_dim.x / 2) {
						actap_right();
					} else {
						actap_left();
					}
				}
			}	
		}
		translate([-relay_sidewalls,-relay_sidewalls,0]) {
			cube(size=[	relay_dim.x + (2 * relay_sidewalls),
						relay_dim.y + (2 * relay_sidewalls),
						relay_cover_height]);
		}
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
	for (i = [0:len(relay_actap_pos)-1]) {
		translate(relay_actap_pos[i]) {
			if (relay_actap_pos[i][x] > relay_dim.x / 2) {
				mount_stem_filled();
			} else {
				mirror([1,0,0])
					mount_stem_filled();
			}
		}
	}
}

module actap_right() {
	difference() {
		mount_stem_filled();
		linear_extrude(relay_cover_height - relay_pcb_inset) {
			circle(r=relay_cover_mount_stem_r - relay_cover_mount_thickness);
			translate([0,-relay_cover_mount_stem_r + relay_cover_mount_thickness,0]) {
				square(size=[11, 2 * (relay_cover_mount_stem_r - relay_cover_mount_thickness)]);
			}
		}
	}	
}

module actap_left() {
	mirror([1,0,0]) 
		actap_right();
}

module mount_stem_right() {
	difference() {
		mount_stem_filled();
		translate([0,0,-relay_cover_thickness]) {
			linear_extrude(relay_cover_height - relay_pcb_inset) {
				circle(r=relay_cover_mount_stem_r - relay_cover_mount_thickness);
				translate([0,-relay_cover_mount_stem_r + relay_cover_mount_thickness,0]) {
					square(size=[11, 2 * (relay_cover_mount_stem_r - relay_cover_mount_thickness)]);
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
	linear_extrude(relay_cover_height - relay_pcb_inset) {
		circle(r=relay_cover_mount_stem_r);
		translate([0,-relay_cover_mount_stem_r]) {
			square(size=[10, 2 * relay_cover_mount_stem_r]);
		}
	}
}

module sides() {
	difference() {
		translate([-relay_sidewalls,-relay_sidewalls,0]) {
			cube(size=[	relay_dim.x + (2 * relay_sidewalls),
						relay_dim.y + (2 * relay_sidewalls),
						relay_cover_height]);
		}
		translate([	0, 
					0,
					relay_cover_thickness]) { 
				cube(size=[	relay_dim.x,
							relay_dim.y,
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