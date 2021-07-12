$fn = 128;

// Wall tickness in mm
wall_thickness = 3;

// internal enclosure size
enclosure_width = 170;
enclosure_height = 152;
enclosure_depth = 180;

// atx psu dimensions
// it assumes atx psu standing vertically, with outer fan to the right side (power connection on top)
atx_width = 86.5;
atx_height = 151;
atx_tolerance = 0.2;
atx_screw = 3;

// Helpers
wt2 = wall_thickness*2;

// enclosure with walls
encl_w = enclosure_width + wt2;
encl_h = enclosure_height + wt2;
encl_d = enclosure_depth + wall_thickness;

// holes
hd = 5; // front hole distance from edge
side_hole_diameter = 2.6;

// backplate helpers
atx_cover_size = 12; // size of lid where atx mounting screws go
atx_vent_border = atx_cover_size;
atx_vent_width = 117; //@todo: calculate this
atx_vent_height = 117;

atx_hole_x = atx_cover_size + wall_thickness;
atx_hole_y = atx_cover_size + wall_thickness;
atx_hole_width = atx_width - (atx_cover_size*2);
atx_hole_height = atx_height - (atx_cover_size*2);

// backpanel
backpanel_right_width = encl_w - atx_width - (atx_cover_size * 2);
backpanel_right_height = encl_h - (atx_cover_size * 2) - (wall_thickness *2);
backpanel_right_x = atx_width + wall_thickness + atx_cover_size;
backpanel_right_y = atx_cover_size + wall_thickness;

grid_width = backpanel_right_width / 3;

module screwHole(diameter) {
    cylinder(h=wall_thickness, r=diameter/2, $fn=128);
}

module backPanel() {
    
    difference() {
        // base plate
        translate([0,0,0]) cube([encl_w, encl_h, wall_thickness]);
        // atx hole
        translate([atx_hole_x, atx_hole_y, 0]) cube([atx_hole_width, atx_hole_height, wall_thickness]);
   
        // ventilation slits
        union() {
            cell_size = wall_thickness + 1;
            grills = floor(atx_hole_height / cell_size);
            for (i = [0:grills]) {
                // first column
                translate([backpanel_right_x, i * cell_size + backpanel_right_y, 0])
                cube([grid_width, wall_thickness, wall_thickness]);
                // second column
                translate([backpanel_right_x + grid_width*2, i * cell_size + backpanel_right_y, 0])
                cube([grid_width, wall_thickness, wall_thickness]);
                
            }
        } 
        
        // atx screw holes
        as1 = 6.5; // path to center of hole;
        as2 = 64.5-atx_screw; // distance between bottom holes
        as3 = 30.0; // distance of top right hole from top
        translate([wall_thickness+as1, wall_thickness+as1, 0]) screwHole(atx_screw);
        translate([wall_thickness+as1, encl_h - wall_thickness - as1, 0]) screwHole(atx_screw);
        translate([wall_thickness + as1+ (atx_screw/2) + as2, encl_h - wall_thickness - as1, 0]) screwHole(atx_screw);
        
        translate([wall_thickness+(atx_width-as1), wall_thickness+as3, 0]) screwHole(atx_screw);        
    }
}

module outerShell() {
    vent_y = encl_h - atx_vent_border - atx_vent_width - wall_thickness;
    cyr_y = encl_h -  atx_vent_border - wall_thickness - (atx_vent_width/2);
    cyl_z = atx_vent_border+wall_thickness+atx_vent_height/2;    
    cyl_r = atx_vent_height/2;
    
    
    
    difference() {
        // outer shell
        translate([0,0,0]) cube([encl_w, encl_h, encl_d]);
        translate([wall_thickness,wall_thickness,0]) cube([enclosure_width, enclosure_height, enclosure_depth+wall_thickness]);
        
        // ventilation hole
        translate([0, vent_y, atx_vent_border+wall_thickness]) cube([wall_thickness, atx_vent_width, atx_vent_height/2]);
        translate([0, cyr_y, cyl_z]) rotate([0,90,0]) cylinder(h=wall_thickness, r=cyl_r);        
        
        // side holes
        //top right        
        translate([0, wall_thickness+hd, encl_d - hd]) rotate([0,90,0]) screwHole(side_hole_diameter);
        // top left
        translate([encl_w -wall_thickness, wall_thickness+hd, encl_d - hd]) rotate([0,90,0]) screwHole(side_hole_diameter);
        // bottom right
        translate([0, encl_h -wall_thickness-hd, encl_d - hd]) rotate([0,90,0]) screwHole(side_hole_diameter);    
        // bottom left
        translate([encl_w -wall_thickness, encl_h -wall_thickness-hd, encl_d - hd]) rotate([0,90,0]) screwHole(side_hole_diameter);    
        
    }    
}


module innerWall() {
    wall_x = wall_thickness + atx_width + atx_tolerance;
    wall_height = wall_thickness+ (atx_height/2);

    // inner wall
    translate([wall_x, wall_thickness,0]) cube([wall_thickness,enclosure_height,wall_height]);    
}

module enclosure() {
    union() {
        backPanel();
        outerShell();
        innerWall();
    }
}

//=========================================================================

// front plate bevel
fp_lid_height = 10;
fp_lid_width = 5;

module fpScrewHole(diameter) {
cylinder(h=fp_lid_width, r=diameter/2, $fn=128);
}

module frontPlate() {
    wt = wall_thickness;
    d = fp_lid_width;
    bar_x = ((enclosure_width-(d*2)) / 2) - (d /2);
    p = (wt + hd) * 2;

    // base lid shape
    difference() {
        union() {
            translate([0,0,0]) cube([encl_w, encl_h, wt]);
            translate([wt, wt, wt]) cube([enclosure_width, enclosure_height, fp_lid_height]);
        }
        // columns
        translate([wt+d, wt+d, wt]) cube([bar_x, enclosure_height-(d*2), fp_lid_height]);
        translate([wt+d+bar_x+d, wt+d, wt]) cube([bar_x, enclosure_height-(d*2), fp_lid_height]);        
        
        // sink wall
        translate([wt, p, wt+d]) cube([enclosure_width, enclosure_height - p - d - wt, fp_lid_height]);
        translate([p, wt, wt+d]) cube([enclosure_width-p-d-wt, enclosure_height, fp_lid_height]);
        
        // screw holes
        translate([wt,wt+hd,wt+hd]) rotate([0,90,0]) fpScrewHole(3);
        translate([wt+enclosure_width-hd,wt+hd,wt+hd]) rotate([0,90,0]) fpScrewHole(3);
        
        translate([wt,enclosure_height + wt-hd,wt+hd]) rotate([0,90,0]) fpScrewHole(3);
        translate([wt+enclosure_width-hd,enclosure_height + wt-hd,wt+hd]) rotate([0,90,0]) fpScrewHole(3);     
    }       

}

//frontPlate();
enclosure();