// Global print tolerance
print_tolerance = 0.2;

// Wall tickness in mm
wall_thickness = 3;

// internal enclosure size
enclosure_width = 170;
enclosure_height = 152;
enclosure_depth = 185;

// atx psu dimensions
// it assumes atx psu standing vertically, with outer fan to the right side (power connection on top)
atx_width = 86.5;
atx_height = 151;
atx_depth = 140;
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
fp_screw_len = 10;

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
    wall_height = wall_thickness+ atx_depth;
    
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

sink_margin = 3;
sink_thickness = wall_thickness - 2;

// panel meters
meter_width = 45 + print_tolerance;
meter_height = 25.8 + print_tolerance;

led_diameter = 3 + print_tolerance;
fuse_diameter = 12.0 + print_tolerance;
terminal_diameter = 7.9 + print_tolerance;
pot_diameter = 7.5 + print_tolerance;

pbtn_width = 13.1 + print_tolerance;
pbtn_height = 8.6 + print_tolerance;

usb_width = 31.2 + print_tolerance;
usb_height = 6.66 + print_tolerance;
usb_depth = 28.6 + print_tolerance;
usb_plug_width = 14.2 + print_tolerance;

module squareSink(width, height) {
     translate([-sink_margin - (width/2), -sink_margin - (height/2), wall_thickness-sink_thickness]) cube([(sink_margin*2)+width, (sink_margin *2)+height, sink_thickness]);    
}

module fpScrewHole(diameter) {
cylinder(h=fp_screw_len, r=diameter/2, $fn=128);
}

// meter hole
// current coords should be the center coords
module fpMeter() {
    translate([-(meter_width/2), -(meter_height/2), 0])
    cube([meter_width, meter_height, wall_thickness]);
    squareSink(meter_width, meter_height);
}

module fpPushBtn() {
    translate([-(pbtn_width/2), -(pbtn_height/2), 0]) cube([pbtn_width, pbtn_height, wall_thickness]);
    squareSink(pbtn_width, pbtn_height);
}

module fpFuse() {
    cylinder(h=wall_thickness, r=fuse_diameter/2, $fn=64);    
}

module fpLeds() {
    width = led_diameter * 3;
    translate([-led_diameter,0,0]) cylinder(h=wall_thickness, r=led_diameter/2, $fn=64);
    translate([led_diameter,0,0]) cylinder(h=wall_thickness, r=led_diameter/2, $fn=64);    
}

module fpTerminal() {
    tr = terminal_diameter/2;
    th = tr/4;
    cylinder(h=wall_thickness, r=tr, $fn=64);
    translate([-tr, 0, 0]) cylinder(h=wall_thickness, r=th, $fn=64);
    translate([tr, 0, 0]) cylinder(h=wall_thickness, r=th, $fn=64);
    squareSink(terminal_diameter, terminal_diameter);    
}

module fpPotentiometer() {
    cylinder(h=wall_thickness, r=pot_diameter/2, $fn=64);    
    squareSink(pot_diameter, pot_diameter);    
}

module fpUsbPanel() {
    translate([-(usb_width/2), -(usb_height/2), 0]) cube([usb_plug_width, usb_height, wall_thickness]);
    translate([(usb_width/2)-usb_plug_width, -(usb_height/2), 0]) cube([usb_plug_width, usb_height, wall_thickness]);
    squareSink(usb_width, usb_height);
}

module fpUsbPanelPlate() {
    margin = 2;
    _x = -(usb_width/2);
    difference() {
        // main block
        translate([_x-margin, -usb_height-1, 0]) cube([usb_width+(margin * 2), margin * 4, usb_depth+wall_thickness]);
        // board sink
        translate([_x-(margin/2), -usb_height+(margin), 0]) cube([usb_width+margin, margin * 3, usb_depth+wall_thickness]);
    }
}


module frontPlate() {
    wt = wall_thickness;
    d = fp_lid_width;
    bar_x = ((enclosure_width-(d*2)) / 2) - (d /2);
    p = (wt + hd) * 2;
    
    grid8_width = encl_w / 8;
    grid10_width = encl_w / 10;
    grid12_width = encl_w / 12;
    
    half_width = encl_w / 2;
    half_d = fp_lid_width / 2;
    usable_width = encl_w - (d*2) - (wt * 2);
    grid8_height = encl_h / 8;
    grid12_height = encl_h / 12;
    
    // base lid shape
    difference() {
        union() {
            translate([0,0,0]) cube([encl_w, encl_h, wt]);
            translate([wt, wt, wt]) cube([enclosure_width, enclosure_height, fp_lid_height]);
        }
        // sink to create border columns
        translate([wt+d, wt+d, wt]) cube([usable_width, enclosure_height-(d*2), fp_lid_height]);
        
        // reduce wall height
        //translate([wt, p, wt+d]) cube([enclosure_width, enclosure_height - p - d - wt, fp_lid_height]);
        //translate([p, wt, wt+d]) cube([enclosure_width-p-d-wt, enclosure_height, fp_lid_height]);
        
        // screw holes - 4mm to fit brass threads
        translate([wt,wt+hd,wt+hd]) rotate([0,90,0]) fpScrewHole(4);
        translate([wt+enclosure_width-fp_screw_len,wt+hd,wt+hd]) rotate([0,90,0]) fpScrewHole(4);
        
        translate([wt,enclosure_height + wt-hd,wt+hd]) rotate([0,90,0]) fpScrewHole(4);
        translate([wt+enclosure_width-fp_screw_len,enclosure_height + wt-hd,wt+hd]) rotate([0,90,0]) fpScrewHole(4);    
       
        // right side ==============
        // hole modules assume center coordinates
        // power push button
        translate([grid8_width *4, grid8_height*7, 0]) fpPushBtn();
        translate([grid8_width *4, grid8_height*6, 0]) fpLeds();
        
        // right meter - step down
        translate([grid8_width*2,grid8_height *6, 0]) fpMeter();
        
        // potentiometers
        translate([grid12_width*3, grid8_height*4,0]) fpPotentiometer();
                
        // power terminals - 0-12v
        translate([grid10_width*2, grid8_height*3,0]) fpTerminal();
        translate([grid10_width*3, grid8_height*3,0]) fpTerminal();        
        
        //fuses
        translate([grid10_width, grid8_height,0]) fpFuse();
        translate([grid10_width*2, grid8_height,0]) fpFuse();

        // usb
        translate([grid12_width*3, grid8_height*2,0]) fpUsbPanel();
        
        // left side ==============
        // hole modules assume center coordinates        
        translate([grid8_width*6,grid8_height *6, 0]) fpMeter();

        // potentiometers
        translate([grid12_width*8, grid8_height*4,0]) fpPotentiometer();
        translate([grid12_width*10, grid8_height*4,0]) fpPotentiometer();
        
        // power terminals - 12-60v
        translate([grid10_width*7, grid8_height*3,0]) fpTerminal();
        translate([grid10_width*8, grid8_height*3,0]) fpTerminal();        
        
        // power terminals - 3.3, 5, 12, gnd
        translate([grid10_width*6, grid8_height*2,0]) fpTerminal();
        translate([grid10_width*7, grid8_height*2,0]) fpTerminal();        
        translate([grid10_width*8, grid8_height*2,0]) fpTerminal();
        translate([grid10_width*9, grid8_height*2,0]) fpTerminal();        
                
        //fuses
        translate([grid10_width*6, grid8_height,0]) fpFuse();
        translate([grid10_width*7, grid8_height,0]) fpFuse();
        translate([grid10_width*8, grid8_height,0]) fpFuse();
        translate([grid10_width*9, grid8_height,0]) fpFuse();
        
    }       
    
    // usb support plates
    translate([grid12_width*3, grid8_height*2,0]) fpUsbPanelPlate();
    
    // support bars
    translate([wt, 47, wt]) cube([enclosure_width,d, d]);
    translate([wt, 95, wt]) cube([enclosure_width,d, d]);
}

module testPlate() {
    r1 = 10 + (meter_width / 2);
    r2 = r1 + 10 + (meter_width / 2) + (pbtn_width /2);
    r3 = r2 + 10 + (pbtn_width /2) + (pot_diameter/2);

    difference() {
        cube([100,55,wall_thickness]);
        
        translate([r1,35,0]) fpMeter();
        translate([r1,10,0]) fpUsbPanel();
        
        translate([r2,40,0]) fpPushBtn();
        translate([r2,25,0]) fpFuse();
        translate([r2,10,0]) fpTerminal();
        
        translate([r3, 40,0]) fpPotentiometer();
    }
    translate([r1,10,0]) fpUsbPanelPlate();    
}
