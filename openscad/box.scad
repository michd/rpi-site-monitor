// This design is parameterized based on holes in a PCB.
// It assumes that the PCB has 4 holes, evenly spaced as
// corners of a rectangle.

// Note: width refers to X axis, depth to Y, height to Z

// Edit these parameters for your own board dimensions

ceiling_distance_to_board = 7;

wall_thickness = 2;
floor_thickness = 2;
ceiling_thickness = 2;


hole_spacing_x = 98.5;
hole_spacing_y = 24.1;

hole_diameter = 2.5;
standoff_diameter = 4;

// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height = 5;
board_thickness = 1.65;


bottom_wall_height = standoff_height;
top_wall_height = ceiling_distance_to_board + board_thickness;
// Total height of box = floor_thickness + ceiling_thickness + bottom_wall_height + top_wall_height

// padding between standoff and wall
padding_left = 3;
padding_right = 3;
padding_back = 3;
padding_front = 3;

// ridge where bottom and top off box can overlap
// Make sure this isn't less than top_wall_height
ridge_height = 2;

// Project-specific params
led_diameter = 5;
first_led_offset_x = 10.2;
first_led_offset_y = 2;
led_origin_spacing = 19;
num_leds = 5;

connector_origin_x = 48.3;
connector_origin_y = 20.3;
connector_width = 20;
connector_depth = 7.5;

//-------------------------------------------------------------------

// Calculated globals
pin_height = bottom_wall_height + top_wall_height - standoff_height; 


module ceilingless_box(width, depth, height) {
    // Floor
    cube([width, depth, floor_thickness]);
    
    // Left wall
    translate([0, 0, floor_thickness])
        cube([
            wall_thickness,
            depth,
            height]);
    
    // Right wall
    translate([width - wall_thickness, 0, floor_thickness])
        cube([
            wall_thickness,
            depth,
            height]);
    
    // Rear wall
    translate([wall_thickness, depth - wall_thickness, floor_thickness])
        cube([
            width - 2 * wall_thickness,
            wall_thickness,
            height]);
    
    // Front wall
    translate([wall_thickness, 0, floor_thickness])
        cube([
            width - 2 * wall_thickness,
            wall_thickness,
            height]);
}

module bottom_case() {
    floor_width = hole_spacing_x + standoff_diameter + padding_left + padding_right + wall_thickness * 2;
    floor_depth = hole_spacing_y + standoff_diameter + padding_front + padding_back + wall_thickness * 2;
    
    module box() {
        ceilingless_box(floor_width, floor_depth, bottom_wall_height);        
        
        // Left Ridge
        translate([
            wall_thickness / 2,
            wall_thickness / 2,
            floor_thickness + bottom_wall_height])
            cube([
                wall_thickness / 2,
                floor_depth - wall_thickness,
                ridge_height]);
        
        
        // Right Ridge
        translate([
            floor_width - wall_thickness,
            wall_thickness / 2,
            floor_thickness + bottom_wall_height])
            cube([
                wall_thickness / 2,
                floor_depth - wall_thickness,
                ridge_height]);
                
        // Rear Ridge
        translate([
            wall_thickness,
            floor_depth - wall_thickness,
            floor_thickness + bottom_wall_height])
            cube([
                floor_width - wall_thickness * 2,
                wall_thickness / 2,
                ridge_height]);
                
        // Front Ridge
        translate([
            wall_thickness,
            wall_thickness / 2,
            floor_thickness + bottom_wall_height])
            cube([
                floor_width - 2 * wall_thickness,
                wall_thickness / 2,
                ridge_height
            ]);
    }
        
    
    // Place the standoffs and through-PCB pins in the box
    module pcb_holder() {        
        base_offset_x = wall_thickness + padding_left + standoff_diameter / 2;
        base_offset_y = wall_thickness + padding_front + standoff_diameter / 2;
        
        module pin() {
            // Standoff
            translate([0, 0,  standoff_height / 2])
                cylinder(
                    r = standoff_diameter / 2,
                    h = standoff_height,
                    center = true,
                    $fn = 20);
            
            // Through-PCB ping
            translate([0, 0, standoff_height + (board_thickness + pin_height) / 2])
                cylinder(
                    r = hole_diameter / 2,
                    h = board_thickness + pin_height,
                    center = true,
                    $fn = 20);
        }
        
        // Front left
        translate([base_offset_x, base_offset_y, floor_thickness])
            pin();
        
        // Front right
        translate([base_offset_x + hole_spacing_x, base_offset_y, floor_thickness])
            pin();
        
        // Rear left
        translate([base_offset_x, base_offset_y + hole_spacing_y, floor_thickness])
            pin();
        
        // Rear right
        translate([base_offset_x + hole_spacing_x, base_offset_y + hole_spacing_y, floor_thickness])
            pin();
        
    }
    
    box();
    pcb_holder();
}

module top_case() {
    floor_width = hole_spacing_x + standoff_diameter + padding_left + padding_right + wall_thickness * 2;
    floor_depth = hole_spacing_y + standoff_diameter + padding_front + padding_back + wall_thickness * 2;
    
    module box() {
        ceilingless_box(floor_width, floor_depth, top_wall_height - ridge_height);
        
        // Left Ridge
        translate([
            0,
            0,
            floor_thickness + top_wall_height - ridge_height])
            cube([
                wall_thickness / 2,
                floor_depth,
                ridge_height]);
        
        
        // Right Ridge
        translate([
            floor_width - wall_thickness / 2,
            0,
            floor_thickness + top_wall_height - ridge_height])
            cube([
                wall_thickness / 2,
                floor_depth,
                ridge_height]);
                
        // Rear Ridge
        translate([
            wall_thickness / 2,
            floor_depth - wall_thickness / 2,
            floor_thickness + top_wall_height - ridge_height])
            cube([
                floor_width - wall_thickness,
                wall_thickness / 2,
                ridge_height]);
                
        // Front Ridge
        translate([
            wall_thickness / 2,
            0,
            floor_thickness + top_wall_height - ridge_height])
            cube([
                floor_width - wall_thickness,
                wall_thickness / 2,
                ridge_height
            ]);        
    }
    
    module pcb_holder() {
        pin_holder_height = pin_height - board_thickness;
        base_offset_x = wall_thickness + padding_left + standoff_diameter / 2;
        base_offset_y = wall_thickness + padding_back + standoff_diameter / 2;
        
        module pin_receiver() {
            difference() {
                translate([0, 0,  pin_holder_height / 2])
                    cylinder(
                        r = standoff_diameter / 2,
                        h = pin_holder_height,
                        center = true,
                        $fn = 20);
                
                translate([0, 0, (pin_holder_height + 2) / 2])
                    cylinder(
                        r = hole_diameter / 2,
                        h = pin_holder_height + 2,
                        center = true,
                        $fn = 20);
           }
        }
        
        // Keep in mind that this part needs to be turned over to get the correct
        // orientation. In the design, the rear left here looks like the front left.
        
        // Rear left
        translate([base_offset_x, base_offset_y, floor_thickness])
            pin_receiver();
        
        // Rear right
        translate([base_offset_x + hole_spacing_x, base_offset_y, floor_thickness])
            pin_receiver();
        
        // Front left
        translate([base_offset_x, base_offset_y + hole_spacing_y, floor_thickness])
            pin_receiver();
        
        // Front right
        translate([base_offset_x + hole_spacing_x, base_offset_y + hole_spacing_y, floor_thickness])
            pin_receiver();
    }
    
    module led_holes() {
        base_offset_x = wall_thickness + padding_left + standoff_diameter / 2;
        base_offset_y = wall_thickness + padding_front + standoff_diameter / 2 + hole_spacing_y;
        
        module hole() {
            translate([
                0,
                0,
                ceiling_thickness / 2])
                    cylinder(
                        r = led_diameter / 2,
                        h = ceiling_thickness + 2,
                        center = true,
                        $fn = 20);    
        }
        
        for (i = [0 : num_leds - 1]) {
            translate([
                base_offset_x + first_led_offset_x + i * led_origin_spacing,
                base_offset_y - first_led_offset_y,
                0])
                hole();
        }
        
    }
    
    module connector_hole() {
        base_offset_x = wall_thickness + padding_left + standoff_diameter / 2;
        base_offset_y = wall_thickness + padding_front + standoff_diameter / 2 + hole_spacing_y;
        translate([
            base_offset_x + connector_origin_x - connector_width / 2,
            base_offset_y - connector_origin_y - connector_depth / 2,
            - ceiling_thickness / 2])
            cube([connector_width, connector_depth, ceiling_thickness * 2]);
    }
    
    difference() {
        box();
        led_holes();
        connector_hole();
    }
        
    pcb_holder();
}


bottom_case();

translate([
    0,
    15 + hole_spacing_y + standoff_diameter + padding_front + padding_back + wall_thickness * 2,
    0])
    top_case();