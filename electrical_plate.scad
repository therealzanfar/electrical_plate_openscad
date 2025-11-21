
$fn = $preview ? 32 : 64;

/* [Part] */

Part=0; // [0:Faceplate, 1:Support Enforcer]

/* [Plate Size] */

// How how far the plate covers around the edges
Plate_Extent=0; // [0:Normal, 1:Midsize, 2:Jumbo]

// How many gangs wide the plate is
Gang_Count=1; // [1:4]

/* [Gang Types] */

// Type of holes in each gang; gangs above the Gang_Count value are ignored
Gang_1_Type=0; // [0:Blank, 1:Toggle, 2:Receptacle, 3:Decora, 5: Aqara Switch]
Gang_2_Type=0; // [0:Blank, 1:Toggle, 2:Receptacle, 3:Decora, 5: Aqara Switch]
Gang_3_Type=0; // [0:Blank, 1:Toggle, 2:Receptacle, 3:Decora, 5: Aqara Switch]
Gang_4_Type=0; // [0:Blank, 1:Toggle, 2:Receptacle, 3:Decora, 5: Aqara Switch]

module __Customizer_Limit__ () {}  // Hide following assignments from Customizer.

in_mm = 25.4;

plate_height = 4.5 * in_mm;
plate_width = 2.75 * in_mm;
plate_pitch = 1.8125 * in_mm;

plate_depth = 0.125 * in_mm;

midsize_ext = 0.38 * in_mm;
jumbo_ext = 0.75 * in_mm;

blank_screw_pitch = 3.28 * in_mm;

screw_pitch_toggle = 2.375 * in_mm;
port_width_toggle = 0.375 * in_mm;
port_height_toggle = 1.0 * in_mm;

screw_pitch_decora = 3.81 * in_mm;
port_width_decora = 1.375 * in_mm;
port_height_decora = 2.625 * in_mm;

recept_radius = 1.34/2 * in_mm;
recept_height = 1.13/2 * in_mm;
recept_pitch = 1.53/2 * in_mm;

edge_radius = 0.125 * in_mm;
plate_thick = 0.0625 * in_mm;

screw_r = (0.1440/2) * in_mm;
screw_csink_r = (0.307+0.263)/4 * in_mm;
screw_csink_d = (0.097+0.013)/4 * in_mm;

PART_TYPE_FACEPLATE = 0;
PART_TYPE_SUPPORT = 1;

GANG_TYPE_BLANK = 0;
GANG_TYPE_TOGGLE = 1;
GANG_TYPE_RECEPT = 2;
GANG_TYPE_DECORA = 3;
GANG_TYPE_AQARA  = 5;

AQARA_HEIGHT = 15.55;
AQARA_BASE = 1.2;

TYPE_PARAMS = [
    [0, 0, 0],
    [screw_pitch_toggle, port_width_toggle, port_height_toggle],
    [0, 0, 0],
    [screw_pitch_decora, port_width_decora, port_height_decora],
];
gang_types = [Gang_1_Type, Gang_2_Type, Gang_3_Type, Gang_4_Type];

//---//

if (Part == PART_TYPE_FACEPLATE)
    faceplate();
    
if (Part == PART_TYPE_SUPPORT)
    support();

module support() {
}

module faceplate() {
    union() {
        difference() {
            faceplate_blank(g=Gang_Count);
            for (g = [0:Gang_Count-1]){

                type = gang_types[g];

                x_center = plate_width/2 - edge_radius + g * plate_pitch;
                y_center = plate_height/2 - edge_radius;
                
                if (type == GANG_TYPE_BLANK)
                    blank_negative(x_center, y_center);
                
                if (type == GANG_TYPE_TOGGLE)
                    toggle_negative(x_center, y_center);
                    
                if (type == GANG_TYPE_RECEPT)
                    recept_negative(x_center, y_center);
                
                if (type == GANG_TYPE_DECORA)
                    decora_negative(x_center, y_center);
                
                if (type == GANG_TYPE_AQARA)
                    blank_negative(x_center, y_center);
            };
        };
        for (g = [0:Gang_Count-1]){

            type = gang_types[g];

            x_center = plate_width/2 - edge_radius + g * plate_pitch;
            y_center = plate_height/2 - edge_radius;
            
            if (type == GANG_TYPE_AQARA)
                aqara_button(x_center, y_center);
        };
    };
 };

module aqara_button(x, y) {
    translate([x, y, AQARA_HEIGHT/2 - AQARA_BASE])
    rotate(a=-90, v=[1, 0, 0])
    import("aqara_button.stl", center=true);
};

module blank_negative(x, y) {
    
    translate([
        x,
        y + blank_screw_pitch/2,
        0
    ])
    screw_csink();
    
    translate([
        x,
        y -+ blank_screw_pitch/2,
        0
    ])
    screw_csink();
};

module toggle_negative(x, y) {
        
    center_cut(
        port_width_toggle, port_height_toggle,
        x, y
    );
    
    translate([
        x,
        y + screw_pitch_toggle/2,
        0
    ])
    screw_csink();
    
    translate([
        x,
        y -+ screw_pitch_toggle/2,
        0
    ])
    screw_csink();
};

module recept_negative(x, y) {
    
    translate([x, y-recept_pitch, 0])
    recept_hole_negative();
    
    translate([x, y+recept_pitch, 0])
    recept_hole_negative();
    
    translate([
        x,
        y,
        0
    ])
    screw_csink();
};

module recept_hole_negative() {
    translate([0, 0, -2*plate_depth])
    difference() {
        cylinder(
            h=3*plate_depth,
            r=recept_radius,
        );
        
        translate([
            -recept_radius,
            recept_height,
            -plate_depth,
        ])
        cube([
            2*recept_radius,
            recept_radius - recept_height,
           5*plate_depth,
        ]);
        
        translate([
            -recept_radius,
            -recept_height - (recept_radius - recept_height),
            -plate_depth,
        ])
        cube([
            2*recept_radius,
            recept_radius - recept_height,
           5*plate_depth,
        ]);
    };
};

module decora_negative(x, y) {
        
    center_cut(
        port_width_decora, port_height_decora,
        x, y
    );
    
    translate([
        x,
        y + screw_pitch_decora/2,
        0
    ])
    screw_csink();
    
    translate([
        x,
        y -+ screw_pitch_decora/2,
        0
    ])
    screw_csink();
};

module center_cut(
    w = 10, h = 10,
    x = 0, y = 0
) {
    
    translate([
        x - w/2,
        y - h/2,
        -2*plate_depth
    ])
    cube([
        w,
        h,
        plate_depth*3
    ]);
}

module screw_csink() {
    rotate_extrude(angle=360)
    polygon([
        [0, plate_depth],
        [screw_csink_r, plate_depth],
        [screw_csink_r, 0],
        [screw_r, -screw_csink_d],
        [screw_r, -2*plate_depth],
        [0, -2*plate_depth],
        [0,plate_depth],
    ]);
};

module faceplate_blank(g=1) {
    
    plate_expand = [
        0,
        midsize_ext,
        jumbo_ext,
    ];
    
    use_height = plate_height + plate_expand[Plate_Extent];
    use_width = plate_width + plate_expand[Plate_Extent];
    
    echo(use_height, use_width);

    h_straight = use_height - 2*edge_radius;
    w_straight = use_width - 2*edge_radius + (g-1) * plate_pitch;
    
    translate([
        0-plate_expand[Plate_Extent]/2,
        h_straight-plate_expand[Plate_Extent]/2,
        0
    ])
    union() {
        // left edge
        translate([0, 0, 0])
        rotate(a=90, v=[1,0,0])
            linear_extrude(h_straight)
            edge_profile();

        // right edge
        translate([w_straight, -h_straight, 0])
        rotate(a=180)
        rotate(a=90, v=[1,0,0])
            linear_extrude(h_straight)
            edge_profile();

            // top edge
        translate([w_straight, 0, 0])
        rotate(a=-90)
        rotate(a=90, v=[1,0,0])
            linear_extrude(w_straight)
            edge_profile();

        // bottom edge
        translate([0, -h_straight, 0])
        rotate(a=90)
        rotate(a=90, v=[1,0,0])
            linear_extrude(w_straight)
            edge_profile();

        // tl corner
        mirror([0, 0, 1])
        rotate(a=-90)
            rotate(a=180, v=[1, 0, 0])
            rotate_extrude(angle=-90)    
            edge_profile();

        // tr corner
        mirror([0, 0, 1])
        translate([w_straight, 0, 0])
        rotate(a=-180)
            rotate(a=180, v=[1, 0, 0])
            rotate_extrude(angle=-90)    
            edge_profile();

        // bl corner
        mirror([0, 0, 1])
        translate([0, -h_straight, 0])
        //rotate(a=90)
            rotate(a=180, v=[1, 0, 0])
            rotate_extrude(angle=-90)    
            edge_profile();

        // br corner
        mirror([0, 0, 1])
        translate([w_straight, -h_straight, 0])
        rotate(a=90)
            rotate(a=180, v=[1, 0, 0])
            rotate_extrude(angle=-90)    
            edge_profile();

        // face
        translate([
            0,
            -h_straight,
            -plate_thick
        ])
        cube([
            w_straight,
            h_straight,
            plate_thick
        ]);
    };
};


module edge_profile() {
    difference() {
        translate([
            0,
            -edge_radius
        ])
        difference() {
            circle(r=edge_radius);
            circle(r=edge_radius - plate_thick);
        };
        translate([
            0,
            -edge_radius*2
        ])
        square([
            edge_radius,
            edge_radius*2
        ]);
        translate([
            -edge_radius,
            -edge_radius*2 - plate_depth
        ])
        square([
            edge_radius*2,
            edge_radius*2
        ]);
    };
};