include <climate_enclosure.h>

//*** DIMENSIONS ***//

//*** ASSEMBLY ***//

*supports();
placeholder_board();
color("white")	jbox_mounting_ears();
color("white")	relay_plate();
color("white")	face_hooks();
color("blue")	label();
*color("grey", 0.5)	placeholder_jbox();

//*** MODULES ***//

module supports() {
	rotate([0,180,0])
		translate([0,0,2 * -relay_pos.z - thickness])
			translate([-jbox_dim.x/2,0,0]) 
			translate(relay_pos) {
				for(i = [0:len(relay_mounting_holes)-1]) {
					translate(relay_mounting_holes[i]) {
						mounting_stem(mounting_hole_depth + thickness,
							hole_r = 0);
					}
				}
			}
}

module label() {
	translate([	relay_pos.x + 10,
				relay_pos.y + 5,
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
	cube(size=face_hook_dim_1);
	translate([face_hook_dim_1.x,0,0]) {
		cube(size=face_hook_dim_2);
		translate([0,0,face_hook_dim_2.z]) {
			cube(size=face_hook_dim_3);
			translate([face_hook_dim_3.x,0,0]) {
				difference() {
					cube(size=face_hook_dim_4);
					translate(face_hook_slot_pos) {
						cube(size=face_hook_slot_dim);
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
		translate([-jbox_dim.x/2,0,2 * -relay_pos.z + mounting_hole_depth])
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
			translate(relay_pos) {
				cube(size=[relay_dim.x, relay_dim.y, thickness]);
				for(i = [0:len(relay_mounting_holes)-1]) {
					translate(relay_mounting_holes[i]) {
						mounting_stem(mounting_hole_depth + thickness);
					}
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