//*** DIMENSIONS ***//
x = 0; y = 1; z = 2;	// simplify array references
printer_layer_height=0.1313;
tol = 0.25;				// tolerance
$fn = 80;				// facet count for curves

// Junction Box
jbox_dim = [51,92,82];
jbox_screw_distance = 83.5; 
jbox_screw_dia = 2.1;	
jbox_ear_width = 20;
jbox_ear_thickness = 1.5;
jbox_ear_pleatau = -15;
jbox_hole_inset = 4;
jbox_mount_dim = [15, 10, jbox_dim.z];

// Dial
dial_pos = [23.63,19.52];
dial_r = 18;

// Faceplate
thickness = 3;
corner_r = 10;
brim_thickness = 13.5;
display_thickness = 8; 
display_window_layers = 3;
display_window_thickness = display_window_layers * printer_layer_height;
display_window_depth = 1;
display_pos = [[10.93,39.44],[10.93,59.76]];
display_dim = [25.4,19,display_thickness];
xdim = 75; //placeholder
ydim = 120;
zdim = display_thickness + display_window_depth;
yoff = -10;

// Control PCB
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
	[3.31,3.08],
	[49.78,35.05],
	[51.01,5.08],
	[3.81,78.81],
	[51.01,78.81]
];

// ESP Backpack
esp_header_dim = [3,38,3];
esp_header_offset = 6;
esp_pos = [23.43,19.59,pcb_dim.z+esp_header_dim.z];
esp_dim = [48,26,1.6];

mounting_stem_r = 6;	
mounting_hole_r = 2.5;		//for T6 screws
mounting_hole_depth = 8;	//for 6mm screws
mounting_stem_support_height = zdim;
mounting_stem_support_base = zdim;
mounting_stem_support_thickness = 2;

hook_pos = [
	[18,40],
	[18,80],
	[69,40],
	[69,80]
];
hook_dim = [3,20,30];
hook_cut_pos = [-1,10,3];
hook_cut_dim = [3, 10];
hook_cut_height = 20;
hook_cut_angle = 2;

// RELAY BOARD

relay_dim = [41.58,62.22,1.6];
relay_pos = [(jbox_dim.x / 2) - (relay_dim.x / 2),
			 jbox_mount_dim.y + 2,
			 -7];
relay_mounting_holes = [
	[3.81,3.81],
	// [38.1,3.81],
	[3.81,58.65],
	[38.1,58.65]
];

// DHT SENSOR
dht_dim = [20.2,15.4,9.4];
dht_pos = [xdim - dht_dim.x - thickness - 7,
		   thickness - 1, 
		   thickness - 1];
dht_slot_dim = [1.5,dht_dim.y + thickness,dht_dim.z];
dht_slot_spacing = 1.5;

// FACEPLATE HOOKS
face_hook_tol = 0.25;
face_hook_thickness = 3;
face_hook_width = 15;
face_hook_jbox_clearance = 2;
face_hook_dim_4 = [ 2,15, brim_thickness - thickness];
face_hook_overreach = (xdim / 2) - (jbox_dim.x / 2) - face_hook_dim_4.x - face_hook_tol;
face_hook_dim_1 = [jbox_dim.x / 2 - face_hook_thickness - face_hook_jbox_clearance,
				   face_hook_width, 
				   thickness];
face_hook_dim_2 = [ thickness,
					face_hook_width,
					-relay_pos.z];
face_hook_dim_3 = [face_hook_overreach + face_hook_jbox_clearance,
				   15, 
				   1.5];
face_hook_slot_dim = [2 + 2, 15/2 + 1,3];
face_hook_slot_pos = [-1,15/2,4];
face_hook_pos = [
	[20, 65],	// left side
	[20, 65]	// right side
];
face_hook_tab_dim = [3,
					 8,
					 face_hook_slot_dim.z - (face_hook_tol * 2)];


// MODULES

module mounting_stem(depth, stem_r = mounting_stem_r, hole_r = mounting_hole_r) {
	difference() {
		linear_extrude(depth) {
			circle(stem_r);
		}
		translate([0,0,depth - mounting_hole_depth]) {
			linear_extrude(mounting_hole_depth + 1) {
				circle(hole_r);
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
