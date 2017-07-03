ball_d=9.15;
extra_tolerance=0.15;
ball_r_2=(ball_d/2)*(ball_d/2);
race_r = ball_d/3;

length=60.2;
thickness=2;
slot_width=6;
$fn=50;
hole_d=5.2;
hole_spacing=25;

function fudge() = cos(180/$fn);

module race_2dp(tol=0) {
    translate([race_r/2, 0]) 
    square([race_r, ball_d+thickness*2], center=true);
    translate([race_r+(ball_d+thickness*2)/2, 0]) {
        difference() {
            union() {
                circle(d=ball_d+thickness*2);
                translate([(ball_d+thickness*2)/4, 0])
                square([(ball_d+thickness*2)/2, ball_d+thickness*2], center=true);
                square([ball_d+thickness*2, ball_d+thickness*2], center=true);
            }
            circle(d=(ball_d+tol)/fudge(), center=true);
        }
    }
}

module tolerance_gradual(tol) {
    if (tol != 0) {
        l=tol*6;
        translate([race_r+(ball_d+thickness*2)/2, length/2-l/2+0.0001, 0])
        rotate([90, 0, 0]) cylinder(d2=ball_d/fudge(), d1=(ball_d+tol)/fudge(), h=l, center=true);
    }
}

module race_3d() {
    translate([0, length/2, 0])
    rotate_extrude(angle=180)
    race_2dp(extra_tolerance);

    rotate(180)
    translate([0, length/2, 0])
    rotate_extrude(angle=180)
    race_2dp(extra_tolerance);

    rotate([90, 0, 0])
    translate([0, 0, -length/2]) linear_extrude(length)
    union() {
        race_2dp();
        mirror([1, 0, 0]) race_2dp(extra_tolerance);
    }
}
module race_slotted() {
    difference() {
        race_3d();
        c=[ball_d*3+race_r*2, length+ball_d*4, ball_d*2];
        translate([c[0]/2+ball_d*3/4, 0, c[2]/2+slot_width/2]) cube(c, center=true);
        translate([0, 0, c[2]/2+ball_d*2/5]) cube(c, center=true);
        translate([c[0]/2+ball_d*3/4, 0, -(c[2]/2+slot_width/2)]) cube(c, center=true);
        for (i = [-hole_spacing : hole_spacing : hole_spacing]) {
            translate([0, i, 0])
            cylinder(d=hole_d/fudge(),h=ball_d*2, center=true);
        }
        tolerance_gradual(extra_tolerance);
        mirror([0, 1, 0]) tolerance_gradual(extra_tolerance);
    }
}

race_slotted();