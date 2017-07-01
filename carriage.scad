ball_d=9+0.2;
ball_r_2=(ball_d/2)*(ball_d/2);
race_r = ball_d;

length=60;
thickness=2;
h=0.1;
slot_width=6;
cover=0.08;


module ball() {
    sphere(d=ball_d, center=true);
}

module race_2d(r) {
    translate([length/2, 0, 0]) circle(r=r, center=true);
    translate([-length/2, 0, 0]) circle(r=r, center=true);
    square([length, r*2], center=true);
}

module race_s(n) {
    difference() {
        offset(thickness+ball_d/2) children();
        offset(n) children();
    }
}


layers = [ball_d*cover-thickness : h : ball_d*(1-cover)];
//lay ers = [0 : 1 : 5];

function circle_offset(z) = (z>=-ball_d/2&&z<=ball_d/2) ? sqrt(ball_r_2 - z*z) : 0;

module race() {
    difference() {
        translate([0, 0, -ball_d/2])  {
            for(n = layers) {
                translate([0, 0, n]) linear_extrude(h)
                //race_s(ball_d/4*sin(180-n*(180/ball_d)))
                race_s(circle_offset(n-ball_d/2))
                race_2d(race_r);
            }
        }
        translate([0, race_r+ball_d/2, ball_d/2+slot_width/2]) cube([length*1.5, race_r, ball_d], center=true);
        translate([0, race_r+ball_d/2, -(ball_d/2+slot_width/2)]) cube([length*1.5, race_r, ball_d], center=true);
    }
}

module race_inner() {
    translate([0, 0, -ball_d/2])  {
        for(n = layers) {
            translate([0, 0, n]) linear_extrude(h)
            offset(-circle_offset(n-ball_d/2))
            race_2d(race_r);
        }
    }
}


race();
color("blue") race_inner();
%translate([0, race_r, 0]) ball($fn=50);