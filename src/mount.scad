include <BOSL2/std.scad>
include <BOSL2/screws.scad>
$fn=256;

// Aqara T1 Shutoff Valve

ih1 = 6; ih2 = 20;
d1 = 0; d2 = 0; d3 = 0;
oh = ih1 + ih2; od = 64;
model = "X";
ch = 43;
aqara_h = 33; aqara_w = 7.2; aqara_d = 16.5;
washer_od = 6.7; washer_id = 4.81;

module mirror2(v) {
    children();
    mirror(v) children();
}
// Modules for different valve fittings
module cutout(model,tuya,d1,d2,d3) { // cutouts for the inner valve type
     cylinder(d=d1,h=ih1);   //ring
     translate([0,0,ih1]) cylinder(d=d3,h=3.5); //lip
     translate([0,0,ih1]) cylinder(d1=d2,d2=d2,h=ih2+10); // clamp base
     bolt_offset = tuya ? -42.5 : -41;    // Tuya bolt height, Aqara bolt height
     translate ([0,bolt_offset,13]) rotate([0,-90,0]) screw_hole("M5,35",head="socket",counterbore=8, $fn=32, $slop=0.0) position(BOT) nut_trap_inline(10);  // controller bolt
     translate([8,-49.5,25]) rotate([0,-90,90]){ linear_extrude(.75) text(model, size=8, valign="top", halign="center",direction="ltr"); } // demarcation   
}
module base() {
  difference() {
     union() { 
         cylinder(d=od,h=oh);  // main body
         translate([0,-20,13]) rotate([90,0,0]) prismoid(size1=[35,oh], size2=[40,40], h=30, rounding=3);  
     }
     //cutout(model="A1", tuya=false, d1=25.5, d2=32.7,d3=d2);    // Aqara (A) with original sharkbite (1)
     //cutout(model="A2", tuya=false, d1=25.5, d2=32.7,d3=d2);    // Aqara (A) with new sharkbite (2)
     //cutout(model="T1", tuya=true, d1=25.5, d2=32.7,d3=d2);    // Tuya (T) with original sharkbite (1)
     cutout(model="T2", tuya=true, d1=25.5, d2=32.7,d3=33.5);    // Tuya (T) with new sharkbite (2)
     
     // cutouts common across all valve types
     mirror2 ([1,0,0]) translate([22.5,0,oh/2]) rotate([-90,0,0]) screw_hole("M5,40",head="socket",counterbore=14, $fn=32, $slop=0.0) position(BOT) nut_trap_inline(18);  // pipe bolts
     translate([-40,-1.5,0]) cube([80,3,40]); // collar slit
     translate([-aqara_w/2,-50,-10]) cube([aqara_w,aqara_d,aqara_h+20]); // controller slot
  }    
}
module washer() {
   difference() { 
       hull() { mirror2([0,1,0]) translate([0,4,0]) cylinder(d=washer_od, h=aqara_w); }
       cylinder(d=washer_id, h=aqara_w);
   }
} 

base();  // mount
//translate ([40,0,0])washer();