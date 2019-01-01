ball_d=9.15;
extra_tolerance=0.25;
ball_r_2=(ball_d/2)*(ball_d/2);
thickness=2;
race_r = ball_d-thickness;

length=75;
slot_width=6;
$fn=50;
hole_d=5;
hole_spacing=30;

c_offset = 21.5 + race_r;
echo(c_offset);
above_gap=1.5;
gap=13.5+above_gap;
top_h=12;

function fudge() = cos(180/$fn);
function hole_slip(d) = d*(5.3/5)*fudge();
function hole_thread(d) = d*(4.4/5)*fudge();

module race_2dp(tol=0) {
    translate([(race_r+0.002)/2, 0]) 
    square([race_r+0.002, ball_d+thickness*2], center=true);
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
        l=tol*10;
        translate([race_r+(ball_d+thickness*2)/2, length/2-l/2+0.002, 0])
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
    translate([0, 0, -(length+0.002)/2]) linear_extrude(length+0.002)
    union() {
        race_2dp();
        mirror([1, 0, 0]) race_2dp(extra_tolerance);
    }
}

module holes() {
    for (i = [-hole_spacing : hole_spacing : hole_spacing]) {
        translate([(i==0?-1:1)*3.5, i, 0])
        cylinder(d=hole_slip(hole_d),h=100, center=true);
    }
}

module race_slotted() {
    render()
    difference() {
        race_3d();
        c=[ball_d*3+race_r*2, length+race_r*4+ball_d*4, ball_d*2];
        translate([c[0]/2+race_r+ball_d*0.4, 0, c[2]/2+slot_width/2]) cube(c, center=true);
        translate([0, 0, c[2]/2+ball_d*2/5]) cube(c, center=true);
        translate([c[0]/2+race_r+ball_d*0.4, 0, -(c[2]/2+slot_width/2)]) cube(c, center=true);
        holes();
        tolerance_gradual(extra_tolerance);
        mirror([0, 1, 0]) tolerance_gradual(extra_tolerance);
    }
}

translate([80, 0, 0]) race_slotted();

%preview();
translate([0, 0, 15+above_gap]) top();

module side() {
    translate([0, 0, top_h/2]) render() linear_extrude(height=gap+top_h, center=true) projection(cut=true) render() translate([0, 0, 5]) race_slotted();
}

module preview() {
    rotate([90, 0, 0]) linear_extrude(100, center=true) import("dxf/30x30.dxf");

    translate([-c_offset, 0, 0]) rotate([180, 0, 0]) race_slotted();
    rotate(180) translate([-c_offset, 0, 0]) rotate([180, 0, 0]) race_slotted();
}

module hole_row() {
    translate([-c_offset, 0, 0]) holes();
}

module top() {
    d=(c_offset+hole_d)*2+1;
    difference() {
        union() {
            translate([0, 0, top_h/2]) cube([d, length+2*(race_r+ball_d+thickness), top_h], center=true);
            translate([-c_offset,0,-gap/2]) side();
            rotate(180) translate([-c_offset,0,-gap/2]) side();
            /*translate([-c_offset,0,-gap/2]) cube([hole_d*2+1, length, gap], center=true);
            rotate(180) translate([-c_offset,0,-gap/2]) cube([hole_d*2+1, length, gap], center=true);*/
        }
        hole_row();
        rotate(180) hole_row();
    }
}