include <climate_enclosure.h>

//*** ASSEMBLY ***//

rotate([0,180,0]) {
	translate([xdim/2,yoff,-brim_thickness]) {
		if (!render_supports) {
			color("red")	fp_label();
		}
		mirror([1,0,0])	{ 
			if (render_supports) {
				supports();
			} else {
				bezeled_asm();
			}
		}
	}
}

module bezeled_asm() {
	intersection() {
		translate([xdim,0,2*bezel_r]) {
			rotate([0,180,0]) {
				bezel();
			}
		}
		asm();
	}	
}

module asm() {
	difference() {
		faceplate();
		dial();
		display_well();
		max_keepout();
		for(i = [0:len(mounting_holes)-1]) {
			translate([0,0,1])
				translate(pcb_pos + mounting_holes[i]) {
					linear_extrude(zdim) {
						circle(mounting_stem_r);
					}
				}
		}
	}
	display_channels();
	brim();
	color("red")	face_hook_tabs();

	for(i = [0:len(mounting_holes)-1]) {
		difference() {
			translate(pcb_pos + mounting_holes[i]) {
				mounting_stem(zdim);
			}
			display_well();
		}
	}

	// placeholder DHT
	if (render_placeholders) {
		translate(dht_pos) {
			color("white") cube(size=dht_dim);
		}
	}

	// DHT mounting stem
	translate(dht_pos) {
		difference() {
			translate([dht_dim.x + 2.5, 
					   dht_dim.y / 2, 
					   0]) {
				mounting_stem(6.5 - 1,
							  stem_r = 5,
							  hole_r = 2.5);
			}
			cube(size=dht_dim);
		}
	}

	// placeholder PCB 
	if (render_placeholders) {
		translate(pcb_pos) {
			color("green") {
				difference() {
					cube(size=pcb_dim);
					for(i = [0:len(mounting_holes)-1]) {
						translate([0,0,-1])
						translate(mounting_holes[i]) {
							linear_extrude(zdim) {
								circle(r=2.1);
							}
						}
					}
				}
			}
			translate([esp_pos.x - esp_dim.x/2,
					   esp_pos.y - esp_dim.y/2,
					   esp_pos.z]) {
				color("lime")
					cube(esp_dim, center=false);
				*color("black") {		
					translate([0, esp_header_offset, -esp_header_dim.z])
						cube(esp_header_dim);
					translate([esp_dim.x - esp_header_dim.x, esp_header_offset, -esp_header_dim.z])
						cube(esp_header_dim);
				}
			}
			translate(dial_pos) {
				color("black")
					cube([13,13,5], center=true);
			}
		}
	}

	// hooks
	*for(i = [0:len(hook_pos)-1]) {
		translate(hook_pos[i]) {
			hook();
		}
	}

}

//*** MODULES ***//

module max_keepout() {
	translate(pcb_pos) {
		translate(max_pos) {
			cube(size=max_dim, center=true);
		}
	}
}

module supports() {
	// PCB Mounting stems
	for(i = [0:len(mounting_holes)-1]) {
		translate(pcb_pos + mounting_holes[i]) {
			mounting_stem(zdim, hole_r=0);
		}
	}
	// DHT mounting stem
	translate(dht_pos) {
		difference() {
			translate([dht_dim.x + 2.5, 
					   dht_dim.y / 2, 
					   0]) {
				mounting_stem(6.5 - 1,
							  stem_r = 5,
							  hole_r = 0);
			}
			cube(size=dht_dim);
		}
	}	
	// Tabs
	face_hook_tabs();
}

module bezel() {
	translate([bezel_r, bezel_r, bezel_r])
		cube(size=[xdim - (2*bezel_r),ydim - (2*bezel_r),bezel_r]);
	translate([bezel_r,0,-brim_thickness]) 
		cube(size=[xdim - (2 * bezel_r), ydim, bezel_r + brim_thickness]);
	translate([0,bezel_r,-brim_thickness]) 
		cube(size=[xdim, ydim - (2 * bezel_r), bezel_r + brim_thickness]);

	translate([0,0,-brim_thickness]) {
		linear_extrude(bezel_r + brim_thickness) {
			translate([bezel_r,bezel_r,0])
				circle(bezel_r);
			translate([xdim - bezel_r,bezel_r,0])
				circle(bezel_r);
			translate([bezel_r,ydim-bezel_r,0])
				circle(bezel_r);
			translate([xdim-bezel_r,ydim-bezel_r,0])
				circle(bezel_r);
		}
	}

	translate([0,0,bezel_r]) {
		translate([0,bezel_r,0]) {
			rotate([-90,0,0]) {
				linear_extrude(ydim - (2 * bezel_r)) {
					translate([bezel_r,0,0])
						circle(bezel_r);
					translate([xdim-bezel_r,0,0])
						circle(bezel_r);
				}
			}
		}

		translate([bezel_r,0,0]) {
			rotate([0,90,0]) {
				linear_extrude(xdim - (2 * bezel_r)) {
					translate([0,bezel_r,0])
						circle(bezel_r);
					translate([0,ydim-bezel_r,0])
						circle(bezel_r);
				}
			}
		}

		translate([bezel_r,bezel_r,0])
			sphere(bezel_r);
		translate([xdim-bezel_r,bezel_r,0])
			sphere(bezel_r);
		translate([bezel_r,ydim-bezel_r,0])
			sphere(bezel_r);
		translate([xdim-bezel_r,ydim-bezel_r,0])
			sphere(bezel_r);
	}
}

module fp_label() {
	translate([-13,35,thickness])
		rotate([0,0,90])
			linear_extrude(0.75)
				text(label_text, size=label_size);
}

module dht_slots() {
	for(i = [0:dht_slot_spacing * 2:dht_dim.x]) {
		translate([	dht_pos.x + i,
					dht_pos.y - thickness,
					dht_pos.z - thickness]) {
			color("cyan")	cube(size=dht_slot_dim);
		}
	}
}

module face_hook_tabs() {
	for(i = [0:len(face_hook_pos[1])-1]) {
		translate([0,face_hook_pos[1][i],relay_pos.z + face_hook_tab_dim.z]) {
			face_hook_tab();
		}
	}	
	for(i = [0:len(face_hook_pos[0])-1]) {
		translate([xdim,face_hook_pos[0][i],relay_pos.z + face_hook_tab_dim.z]) {
			mirror([1,0,0])
				face_hook_tab();
		}
	}	
}

module face_hook_tab() {
	tab_x = xdim - thickness - face_hook_tab_dim.x;
	tab_z = face_hook_dim_2.z + face_hook_slot_pos.z + face_hook_tol;
	translate([tab_x, -yoff + face_hook_slot_pos.y, tab_z]) {
		cube(size=face_hook_tab_dim);
	}
}

module hook() {
	difference() {
		cube(size=hook_dim);
		translate([-1,-1,hook_cut_height])
			cube(size=[hook_dim.x + 2, hook_cut_dim.y + 1, hook_cut_dim.x]);
	}
}

module faceplate() {
	difference() {
		cube(size=[xdim, ydim, thickness]);
		translate(dht_pos) {
			cube(size=dht_dim);
		}
		dht_slots();
	}
}

module brim() {
	difference() {
		cube(size=[xdim, ydim, brim_thickness]);
		translate([thickness, thickness, -1]) {
			cube(size=[xdim - (2 * thickness),
					   ydim - (2 * thickness),
					   brim_thickness + 2]);
		}
		translate(dht_pos) {
			cube(size=[dht_dim.x,
					   dht_dim.y,
					   brim_thickness]);
		}
		dht_slots();
	}
}

module dial() {
	translate([pcb_pos.x + dial_pos.x, pcb_pos.y + dial_pos.y, -1]) {
		linear_extrude(zdim + 2) {
			circle(dial_r + dial_faceplate_tol);
		}
	}
}

module display_well() {
	for (i = [0:len(display_pos)-1]) {
		translate([pcb_pos.x + display_pos[i][x] - display_tolerance,
				   pcb_pos.y + display_pos[i][y] - display_tolerance,
				   -1]) {
			cube(size=[	display_dim.x + (2*display_tolerance),
						display_dim.y + (2*display_tolerance),
						display_dim.z]);;
		}
	}
}

module display_channels() {
	for (i = [0:len(display_pos)-1]) {
		translate(pcb_pos + display_pos[i]) {
			difference() {
				translate([	-display_tolerance,
							-display_tolerance,
							0]) {
					cube(size=[display_dim.x + (2*display_tolerance),
							   display_dim.y + (2*display_tolerance),
							   display_window_depth]);;
				}
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
