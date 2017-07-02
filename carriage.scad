ball_d=9.1;
ball_r_2=(ball_d/2)*(ball_d/2);
race_r = ball_d/3;

length=58;
thickness=2;
slot_width=6;
$fn=100;

module race_2dp() {
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
            circle(d=ball_d, center=true);
            x=ball_d/4;
            translate([0, ball_d/2-x*0.29]) polygon([[-x, 0], [x, 0], [0, x*2/4]]);
            z=ball_d*3/8;
            translate([0, ball_d*2/6]) polygon([[-z, 0], [z, 0], [0, z*2/3]]);
        }
    }
}

module race_3d() {
    translate([0, length/2, 0])
    rotate_extrude(angle=180)
    race_2dp();

    rotate(180)
    translate([0, length/2, 0])
    rotate_extrude(angle=180)
    race_2dp();

    rotate([90, 0, 0])
    translate([0, 0, -length/2]) linear_extrude(length)
    union() {
        race_2dp();
        mirror([1, 0, 0]) race_2dp();
    }
}
module race_slotted() {
    difference() {
        race_3d();
        c=[ball_d*3+race_r*2, length+ball_d*4, ball_d*2];
        translate([c[0]/2+ball_d*3/4, 0, c[2]/2+slot_width/2]) cube(c, center=true);
        translate([c[0]/2+ball_d*3/4, 0, -(c[2]/2+slot_width/2)]) cube(c, center=true);
    }
}


module ball() {
    sphere(d=ball_d, center=true);
}


race_slotted();
%translate([0, race_r, 0]) ball($fn=50);