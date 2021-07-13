// Global print tolerance
print_tolerance = 0.2;

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
atx_tolerance = print_tolerance;
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

atx_hole_x = encl_w- wall_thickness - atx_width + atx_cover_size;
atx_hole_y = wall_thickness+atx_cover_size;
atx_hole_width = atx_width - (atx_cover_size*2);
atx_hole_height = atx_height - (atx_cover_size*2);

// backpanel
backpanel_grid_width = (encl_w/2) - (atx_cover_size * 2) - wall_thickness;
backpanel_grid_height = encl_h - (atx_cover_size * 2) - (wall_thickness *2);
grid_width = backpanel_grid_width / 3;
backpanel_grid_x = wall_thickness + atx_cover_size;
//encl_w-(atx_width + wall_thickness + (atx_cover_size * 2));
backpanel_grid_y = atx_cover_size + wall_thickness;

//===========================================================================
// Hex Grid Helpers
//===========================================================================
grid_diameter = 3;

module hexagon(){
    translate([0, 0, -0.1]) rotate([0, 0, 30]) cylinder(d = grid_diameter, h = wall_thickness + print_tolerance, $fn = 6);
}



module invertedHoneyComb(width, height) {
    a = (grid_diameter + (wall_thickness/2))*sin(60);
    for(x = [grid_diameter/2: a: width]) {
        for(y = [grid_diameter/2: 2*a*sin(60): height]) {
            translate([x, y, 0]) hexagon();
            translate([x + a*cos(60), y + a*sin(60), 0]) hexagon();
        }
    }
        
}

//===========================================================================
// Hole Helpers
//===========================================================================

module screwHole(diameter) {
    cylinder(h=wall_thickness, r=diameter/2, $fn=128);
}

//===========================================================================
// Enclosure
//===========================================================================

module backPanel() {
    
    difference() {
        // base plate
        translate([0,0,0]) cube([encl_w, encl_h, wall_thickness]);
        // atx hole
        translate([atx_hole_x, atx_hole_y, 0]) cube([atx_hole_width, atx_hole_height, wall_thickness]);

        // atx screw holes
        as1 = 6.5; // path to center of hole;
        as2 = 64.5-atx_screw; // distance between bottom holes
        as3 = 30.0; // distance of top right hole from top
        
        translate([atx_hole_x-atx_cover_size+as1, wall_thickness+as1, 0]) screwHole(atx_screw);
        translate([atx_hole_x-atx_cover_size+as1, encl_h - wall_thickness - as1, 0]) screwHole(atx_screw);
        translate([atx_hole_x-atx_cover_size+as1  +(atx_screw/2) + as2, encl_h - wall_thickness - as1, 0]) screwHole(atx_screw);        
        translate([encl_w - wall_thickness -as1, wall_thickness+as3, 0]) screwHole(atx_screw);        
    }
}

module outerShell() {

    difference() {
        // outer shell
        translate([0,0,0]) cube([encl_w, encl_h, encl_d]);
        translate([wall_thickness,wall_thickness,0]) cube([enclosure_width, enclosure_height, enclosure_depth+wall_thickness]);
        
        // ventilation - sides
        vent_width = (enclosure_height- atx_cover_size * 2);
        vent_height = (enclosure_depth - (atx_cover_size * 2)) / 2;
        h = vent_height / 2;
        translate([wall_thickness, wall_thickness+atx_cover_size, wall_thickness+atx_cover_size + h]) rotate([0,-90,0]) invertedHoneyComb(vent_height, vent_width);    
 
       
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
    wall_x = encl_w - wall_thickness - atx_width - atx_tolerance - wall_thickness;
    wall_height = wall_thickness+ atx_height;
    
    vent_y = encl_h -  atx_cover_size - wall_thickness - (atx_vent_width/2);
    vent_z = atx_vent_border+wall_thickness+atx_vent_height/2;    
    vent_r = atx_vent_height/2;
    

    difference() {
        // inner wall
        translate([wall_x, wall_thickness,0]) cube([wall_thickness,enclosure_height,wall_height]); 
        // ventilation circle
        translate([wall_x, vent_y, vent_z]) rotate([0,90,0]) cylinder(h=wall_thickness, r=vent_r);        
    }
    
    // shelf
    translate([0, (encl_w /2)-(wall_thickness *2), 0]) cube([wall_x,wall_thickness, wall_height]); 
    
}

module enclosure() {
    union() {
        backPanel();
        outerShell();
        innerWall();
    }
}

//===========================================================================
// Front Plate
//===========================================================================


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
