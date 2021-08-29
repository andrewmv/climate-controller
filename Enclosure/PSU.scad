xdim = 23.497 + 1.5;
ydim = 18.155;
zdim = 13.5; 
wt = 1;
a = 0.897;
b = 4.364;
c = 10.222;
d = 3.168;
e = 1.495;
f = 3.168;

conn_pos = [a, a+b+c, a+b+c+d+e];
conn_dim = [
    [b, 8],
    [d, 8],
    [f, 8]
];

div_width = 0.5;
div_reach = 2.8;
div_pos = a+b+c+d+(e/2)-(div_width/2);

translate([wt + div_pos, wt, 0]) {
    cube(size=[div_width, div_reach, zdim]);
}

difference() {
    cube(size=[ xdim + (2 * wt),
                ydim + (2 * wt),
                zdim + wt]);
    translate([wt,wt,-1]) {
        cube(size=[ xdim,
                    ydim,
                    zdim + 1]);
    }
    conn_cuts();
}

module conn_cuts() {
    translate([wt, -1, 0]) {
        for(i = [0:1:len(conn_pos) - 1]) {
            translate([ conn_pos[i], 0, -wt]) {
                cube([  conn_dim[i][0],
                        wt + 2,
                        conn_dim[i][1] + 1]);
            }
        }
    }
}

//color("red")    conn_cuts();