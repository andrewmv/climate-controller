//*** DIMENSIONS ***//
x = 0; y = 1; z = 2;	// simplify array references
printer_layer_height=0.1313;
tol = 0.25;				// tolerance
$fn = 80;				// facet count for curves

label_text = "2021-09 v3.2";
label_size = 5;

// Include non-printing placeholder compoenents
render_placeholders = false;

// Only render mesh overlap structures
render_supports = false;

// Junction Box
jbox_dim = [51,92,82];
jbox_screw_distance = 83.5; 
jbox_screw_dia = 2.1;	
jbox_ear_width = 20;
jbox_ear_thickness = 3;
jbox_ear_pleatau = -15;
jbox_hole_inset = 4;
jbox_mount_dim = [15, 10, jbox_dim.z];

// Dial
dial_pos = [23.63,19.52];
dial_r = 18;
dial_bezel_r = 3;
dial_depth = 10.5;
dial_walls = 1.5;
dial_shaft_depth = 5;
dial_shaft_r = 10 / 2;
dial_hole_r = 6.25 / 2;
dial_hole_cut = (dial_hole_r * 2) - 4.75;
dial_faceplate_tol = 1.0;

// Faceplate
face_pos = [0, -5, 0];
thickness = 3;
corner_r = 10;
// brim_thickness = 13.5;
brim_thickness = 19.5 + 5;
display_thickness = 8; 
display_window_layers = 3;
display_window_thickness = display_window_layers * printer_layer_height;
display_window_depth = 1;
display_pos = [[10.93,39.44],[10.93,59.76]];
display_dim = [25.4,19,display_thickness];
display_tolerance = 0.25;
xdim = 75; //placeholder
ydim = 115;
zdim = display_thickness + display_window_depth;
yoff = -10;

// MAX IC keepout
max_pos = [47.20,55.95]; // centered
max_dim = [10,34,4];

// Control PCB
pcb_dim = [54.8,82.29,1.6];
pcb_pos = [
	(xdim / 2) - dial_pos.x,
	(ydim / 2) - (pcb_dim.y / 2) + 5,
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
esp_dim = [48,26,4];

mounting_stem_r = 8.75/2;	
relay_mounting_stem_r = 7.75/2;	
mounting_hole_r = 2.75/2;		//for M2 screws
//mounting_hole_depth = 5;	//for 6mm long screws
mounting_stem_support_height = zdim;
mounting_stem_support_base = zdim;
mounting_stem_support_thickness = 2;

hook_dim = [3,20,30];
hook_cut_pos = [-1,10,3];
hook_cut_dim = [3, 10];
hook_cut_height = 20;
hook_cut_angle = 2;

// RELAY BOARD

relay_dim = [41.58,62.22,1.6];
relay_pos = [(jbox_dim.x / 2) - (relay_dim.x / 2),
			 jbox_mount_dim.y + 7,
			 -9.5];
relay_mounting_holes = [
	[3.81,3.81],
	[38.1,3.81],
	[3.81,58.65],
	[38.1,58.65]
];
relay_cover_height = 15.0;
relay_cover_thickness = 1.5;
relay_cover_mount_stem_r = 3.75;
relay_cover_mount_hole_r = 1.9;
relay_cover_mount_thickness = 1;
relay_sidewalls = 1.5;	 //TODO, merge this with thickness
relay_pcb_inset = 5.5;
relay_threaded_insert_depth = 8; //For M2x8x3.5 inserts
// NOTE: the following amount of the threaded brass insert should
// be left protruding:
// relay_pcb_inset - relay_dim.z = 5.5 - 1.6 = 3.9

// array of tuples, [pos,length]
// relay_conn_openings = [
// 	[8.0,9.0],
// 	[32.0,4],
// 	[42.5,4]
// ];
relay_actap_pos = [ [relay_dim.x-3.81,34.29],[relay_dim.x-3.81,44.45] ];
relay_passthrough_pos = [6.35 - 2,13.7 - 1];
relay_passthrough_dim = [4+2,8+2,10];
relay_conn_height=relay_pcb_inset - relay_dim.z;

// DHT SENSOR
dht_dim = [20.2,16.4,9.4];
dht_pos = [xdim - dht_dim.x - thickness - 11,
		   thickness, 
		   thickness - 1];
dht_slot_dim = [1.5,dht_dim.y + thickness,dht_dim.z];
dht_slot_spacing = 1.5;

// FACEPLATE HOOKS
face_hook_tol = 0.25;
face_hook_thickness = 3;
face_hook_width = 15;
face_hook_jbox_clearance = 2;
face_hook_dim_4 = [ 2,15, 10];
face_hook_overreach = (xdim / 2) - (jbox_dim.x / 2) - face_hook_dim_4.x - face_hook_tol;
face_hook_dim_1 = [12,
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
	[8, 70],	// left side
	[8, 70]	// right side
];
face_hook_tab_dim = [3,
					 8,
					 face_hook_slot_dim.z - (face_hook_tol * 2)];

// BEZEL

bezel_r = 5;

// MODULES

module mounting_stem(depth, stem_r = mounting_stem_r, hole_r = mounting_hole_r) {
	difference() {
		linear_extrude(depth) {
			circle(stem_r);
		}
		translate([0,0,2]) {
			linear_extrude(depth + 1) {
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
