include <BOSL2/std.scad>
include <BOSL2/screws.scad>
$fn=128;

// Mount offset 
ih1 = 6; ih2 = 20;
oh = ih1 + ih2; od = 60;
ch = 33;
aqara_h = 33; aqara_w = 7.2; aqara_d = 16.5;
washer_od = 6.7; washer_id = 4.81;

// example usage: mirror2 ([1,0,0]) translate ([35,0,0]) mounts();

module mirror2(v) {
    children();
    mirror(v) children();
}

// These are the various modules used for different valve fittings
module shark() {
     d1 = 25.5; d2 = 32.25; d3 = d2;
     cylinder(d=d1,h=ih1);   //ring
     translate([0,0,ih1]) cylinder(d1=d2,d2=d2,h=ih2+10); // clamp base
}
module newshark() {
     d1 = 25.5; d2 = 32.7; d3 = 33.5;
     cylinder(d=d1,h=ih1);   //ring
     translate([0,0,ih1]) cylinder(d=d3,h=3.5); //lip
     translate([0,0,ih1]) cylinder(d1=d2,d2=d2,h=ih2+10); // clamp base
}

module base() {
  difference() {
     hull() { 
         mirror2 ([1,0,0]) translate ([26,0,0]) cylinder(d=18,h=oh);
         cylinder(d=od,h=oh);
         translate([0,-30,ch/2]) cuboid([30,40,ch], rounding=3, edges="Z");
     }
     shark();    // shark(), newshark(), other mounting sizes modules go here.
     mirror2 ([1,0,0]) translate([22.5,-7,oh/2]) rotate([90,0,0]) screw_hole("M5,45",head="socket",counterbore=15, $fn=32, $slop=0.0) position(BOT) nut_trap_inline(15);  // pipe bolt holes
     translate ([0,-41,ch/2]) rotate([0,90,0]) screw_hole("M5,35",head="socket",counterbore=8, $fn=32, $slop=0.0) position(BOT) nut_trap_inline(10);  // aqara bolt holes
     translate([-40,-1.5,0]) cube([80,3,40]); // pipe opening
     translate([-aqara_w/2,-50,0]) cube([aqara_w,aqara_d,aqara_h]);
  }    
}
module washer() {
   difference() { 
       hull() { mirror2([0,1,0]) translate([0,4,0]) cylinder(d=washer_od, h=aqara_w); }
       cylinder(d=washer_id, h=aqara_w);
   }
} 

base();  // Pipe mount
translate ([40,0,0])washer();