include <climate_enclosure.h>

//*** DIMENSIONS ***//

//*** ASSEMBLY ***//

if (render_supports) {
	supports();
} else {
	difference() {
		union() {
			if (render_placeholders) {
				placeholder_board();
				*color("grey", 0.5)	placeholder_jbox();
			}
			color("cyan")	jbox_mounting_ears();
			color("white")	relay_plate();
			color("blue")	label();
			*color("pink")	sidewalls();
			color("cyan")	face_hooks();
		}
		color("red")	relay_passthrough();
		translate([0,0,-1])
			relay_mounting_stems(0);
	}
	relay_mounting_stems(mounting_hole_r);
}


//*** MODULES ***//

module sidewalls() {
	rotate([0,180,0]) {
		translate([	-relay_dim.x/2,
					relay_pos.y,
					-relay_pos.z]) {
			difference() {
				cube(size=[	relay_dim.x,
							relay_dim.y,
							mounting_hole_depth]);
				translate([	relay_sidewalls,
							relay_sidewalls,
							-1]) {
					cube(size=[	relay_dim.x - (2 * relay_sidewalls),
								relay_dim.y - (2 * relay_sidewalls),
								mounting_hole_depth + 2]);
				}
				for(i = [0:len(relay_mounting_holes)-1]) {
					translate(relay_mounting_holes[i]) {
						mounting_stem(mounting_hole_depth + thickness,
							hole_r = 0);
					}
				}
			}
		}
	}
}

module relay_mounting_stems(r) {
	stem_depth = relay_threaded_insert_depth - relay_pcb_inset + relay_dim.z + 2;
	translate([jbox_dim.x/2,0,stem_depth]) { 
		rotate([0,0,180]) {
			translate([relay_pos.x, -relay_pos.y - relay_dim.y, relay_pos.z]) {
				for(i = [0:len(relay_mounting_holes)-1]) {
					translate(relay_mounting_holes[i]) {
						translate([0,0, 0]) {
							rotate([180,0,0]) {
								mounting_stem(stem_depth, stem_r = relay_mounting_stem_r, hole_r = r);
							}
						}
					}
				}
			}
		}
	}
}

module supports() {
	relay_mounting_stems(0);
}

module label() {
	translate([	relay_pos.x + 8,
				relay_pos.y + 10,
				relay_pos.z+thickness])
		rotate([0,0,90])
			linear_extrude(0.75)
				text(label_text, size=label_size);
}

module face_hooks() {
	for(i = [0:len(face_hook_pos[1])-1]) {
		translate([0,face_hook_pos[1][i],relay_pos.z]) {
			face_hook_right();
		}
	}
	for (i = [0:len(face_hook_pos[0])-1]) {
		translate([0,face_hook_pos[0][i],relay_pos.z]) {
			face_hook_left();
		}
	}
}

module face_hook_left() {
	mirror([1,0,0])
		face_hook_right();
}

module face_hook_right() {
	//difference() {
		translate([jbox_dim.x/2 - face_hook_dim_1.x - face_hook_jbox_clearance - thickness,0,0]) {
			if (!render_supports) {
				cube(size=face_hook_dim_1);
			}
			translate([face_hook_dim_1.x,0,0]) {
				cube(size=face_hook_dim_2);
				translate([0,0,face_hook_dim_2.z]) {
					cube(size=face_hook_dim_3);
					translate([face_hook_dim_3.x,0,0]) {
						difference() {
							cube(size=face_hook_dim_4);
							translate(face_hook_slot_pos) {
								cube(size=face_hook_slot_dim);
								translate([	0,
											12,
											-5.5]) {
									rotate([45,0,0]) {
										cube(size=10);
									}
								}
							}
						}
					}
				}
			}
		}
}

module placeholder_jbox() {
	translate([-jbox_dim.x/2,0,-jbox_dim.z]) {
		difference() {
			translate([-3,-3,-3])
				cube([jbox_dim.x + 6,
					   jbox_dim.y + 6,
					   jbox_dim.z + 3]);
			cube([jbox_dim.x, jbox_dim.y, jbox_dim.z + 1]);
		}
		translate([(jbox_dim.x/2) - (jbox_mount_dim.x/2), 0, 0]) {
			cube(jbox_mount_dim);
			translate([0,jbox_dim.y - jbox_mount_dim.y ,0])
				cube(jbox_mount_dim);
		}
	}
}

module placeholder_board() {
	rotate([0,180,0])
		translate([-jbox_dim.x/2,0,2 * -relay_pos.z + relay_pcb_inset - relay_dim.z])
			color("green") {
				translate(relay_pos) {
					difference() {
						cube(size=relay_dim);
						for(i = [0:len(relay_mounting_holes)-1]) {
							translate([0,0,-1])
							translate(relay_mounting_holes[i]) {
								linear_extrude(zdim) {
									circle(r=2.1);
								}
							}
						}
					}
				}
			}
}

module relay_plate() {
	rotate([0,180,0])
		translate([0,0,2 * -relay_pos.z - thickness])
			translate([-jbox_dim.x/2,0,0]) 
			translate([relay_pos.x - relay_cover_thickness,relay_pos.y,relay_pos.z]) {
				cube(size=[relay_dim.x + (2 * relay_cover_thickness), relay_dim.y, thickness]);
			}
}

module relay_passthrough() {
	rotate([0,180,0])
		translate([0,0,2 * -relay_pos.z - thickness ])
			translate([-jbox_dim.x/2,0,0]) 
			translate([relay_pos.x - relay_cover_thickness,relay_pos.y,relay_pos.z]) {
				translate([	relay_dim.x - relay_passthrough_pos.x,
							relay_dim.y - relay_passthrough_pos.y] ) {
					cube(size=relay_passthrough_dim, center=true);
				}
			}
}

module jbox_mounting_ears() {
	translate([0,jbox_hole_inset,0]) {
		jbox_mounting_ear();
		translate([0,jbox_screw_distance,0]) {
			rotate([0,0,180]) {
				jbox_mounting_ear();
			}
		}
	}
	translate([-jbox_ear_width/2, jbox_mount_dim.y, relay_pos.z]) {
		cube([jbox_ear_width, 
			  jbox_dim.y - (2 * jbox_mount_dim.y) - 2, 
			  thickness]);
	}
}

module jbox_mounting_ear() {
	linear_extrude(jbox_ear_thickness) {
		difference() {
			intersection() {
				square([jbox_ear_width, 12], center=true);
				translate([0, jbox_ear_pleatau, 0]) {
					rotate([0,0,45]) {
						square([50,50]);
					}
				}
			}
			circle(r=jbox_screw_dia);
		}
	}
	translate([-jbox_ear_width/2, jbox_mount_dim.y - jbox_hole_inset, relay_pos.z]) {
		cube([jbox_ear_width, thickness, -relay_pos.z + jbox_ear_thickness]);
	}
}

module fplate_mount() {

}