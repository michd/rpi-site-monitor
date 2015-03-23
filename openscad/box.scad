// This design is parameterized based on holes in a PCB.
// It assumes that the PCB has 4 holes, evenly spaced as
// corners of a rectangle.

// Note: width refers to X axis, depth to Y, height to Z

wall_thickness = 1.75;
floor_thickness = 2;

hole_spacing_x = 98.5;
hole_spacing_y = 19;

hole_diameter = 2.5;
standoff_diameter = 4;
// How much the PCB needs to be raised from the bottom
// to leave room for solderings and whatnot
standoff_height = 5;
board_thickness = 1.65;

// Height of the through-hole pin above sticking out from board
// TODO: this should rely on tbd params of the top of the case
pin_height = 5;

padding_left = 3;
padding_right = 3;
padding_back = 3;
padding_front = 3;

bottom_wall_height = 10;
// ridge where bottom and top off box can overlap
ridge_height = 2;


module bottom_case() {
    floor_width = hole_spacing_x + standoff_diameter + padding_left + padding_right + wall_thickness * 2;
    floor_depth = hole_spacing_y + standoff_diameter + padding_front + padding_back + wall_thickness * 2;
    
    module box() {
        // Floor
        cube([floor_width, floor_depth, floor_thickness]);
        
        // Left wall
        translate([0, 0, floor_thickness])
            cube([
                wall_thickness,
                floor_depth,
                bottom_wall_height - ridge_height]);
        // Ridge
        translate([
            wall_thickness / 2,
            wall_thickness / 2,
            floor_thickness + bottom_wall_height - ridge_height])
            cube([
                wall_thickness / 2,
                floor_depth - wall_thickness,
                ridge_height]);
        
        // Right wall
        translate([floor_width - wall_thickness, 0, floor_thickness])
            cube([
                wall_thickness,
                floor_depth,
                bottom_wall_height - ridge_height]);
        
        // Ridge
        translate([
            floor_width - wall_thickness,
            wall_thickness / 2,
            floor_thickness + bottom_wall_height - ridge_height])
            cube([
                wall_thickness / 2,
                floor_depth - wall_thickness,
                ridge_height]);
        
        // Rear wall
        translate([wall_thickness, floor_depth - wall_thickness, floor_thickness])
            cube([
                floor_width - 2 * wall_thickness,
                wall_thickness,
                bottom_wall_height - ridge_height]);
                
        // Ridge
        translate([
            wall_thickness,
            floor_depth - wall_thickness,
            floor_thickness + bottom_wall_height - ridge_height])
            cube([
                floor_width - wall_thickness * 2,
                wall_thickness / 2,
                ridge_height]);
        
        // Front wall
        translate([wall_thickness, 0, floor_thickness])
            cube([
                floor_width - 2 * wall_thickness,
                wall_thickness,
                bottom_wall_height - ridge_height]);
                
        // Ridge
        translate([
            wall_thickness,
            wall_thickness / 2,
            floor_thickness + bottom_wall_height - ridge_height])
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

bottom_case();