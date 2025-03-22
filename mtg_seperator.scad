include <BOSL2/std.scad>
include <BOSL2/walls.scad>

/* [Card Size] */

card_height = 64;//[30:120]
card_width = 88;//[20:100]
divider_thickness = 1;//[1,1.2,1.4]
mtg_color =  "green"; //[none, green, blue, black, white, red]

/* [Label] */
//Text to appear on the label
label = "A";
//4 is about the smallest that will print nicely on a 4mm nozzle
text_size = 5;//[4:0.5:7]
label_side = "left";//[left,right,middle]
label_width = 20;
label_height = 10;
max_tabs = 5; // [0:1:10]
label_offset = 0; //[0:1:max_tabs]

/* [Pattern] */
pattern = "None";//[None,Hex, Empty]
fill_thickness = 2;//[1:0.5:5]

/* [Colors] */
card_color = "#fdfefe";//color
label_color = "#17202a";//color

/* [Hidden] */
border_width = 16;
rounding = 2;//[1,2,3]

// Generate Infill Pattern

module full() {
    difference(){
        color(card_color)
        resize([0,0,divider_thickness])
                cuboid([card_width,card_height,6], rounding=rounding); 
}
}
module hexfill() {
    difference() {      
        difference() {
            color(card_color)
            resize([0,0,divider_thickness])
                cuboid([card_width,card_height,6], rounding=rounding);
        }
    color(card_color)
    cuboid([card_width-border_width,card_height-border_width,divider_thickness]);
    //cube([card_width-10,card_height-10, divider_thickness]);
    }
    color(card_color)
    hex_panel([card_width-border_width, card_height-border_width, divider_thickness], fill_thickness, 12, frame = 0);
}

module emptyfill() {
    difference() {   
            difference () {
            color(card_color)
resize([0,0,divider_thickness])
                cuboid([card_width,card_height,6], rounding=rounding);
            if(deboss==1) { deboss();}  
            }
    cuboid([card_width-border_width,card_height-border_width,divider_thickness]);
    //cube([card_width-10,card_height-10, divider_thickness]);
    }
}
//Generate Label

translate([label_width/2,label_height/2-3,divider_thickness/2]){
    color(card_color)
    resize([0,0,divider_thickness])
                cuboid([label_width,label_height+3,6], rounding=rounding, except=FRONT);
}

//Generate Text

translate([(label_width) / 2, ((label_height) / 2)-2, divider_thickness]) { // Centers the text
    color(label_color)
    linear_extrude(0.4)  // Raise the text above the surface
    text(label, size=text_size, halign="center", valign="center");
    

}
    // Add mana icon
    if(mtg_color != "none") {
        // Manual tweaking of the icon position, I am sure a better way exists
        translate([label_width-7, label_height / 2 -4,divider_thickness]){
            scale([.02,.02,1])
            color(label_color)
            linear_extrude(0.4)
            import(str("img/", mtg_color, ".svg"));
        }

    
}


//Generate Card


// Math the label out
if(label_offset < max_tabs)  {
    // Within the range
    x_offset = card_width / 2 - (card_width / (max_tabs +.5)) * label_offset - 1;
    y_offset = -card_height/2;
    z_offset = divider_thickness/2;
    translate([x_offset,y_offset,z_offset]) {
        if(pattern=="None"){ full(); }
        if(pattern=="Hex") { hexfill();}
        if(pattern=="Strut") { strutfill();}
        if(pattern=="Empty") { emptyfill();}
    }
} else {
    // Last tab overflows
    
    
}

//Allow for imprints on the divider (version, game name, etc)
module deboss() {
    translate([0, (-card_height+8) / 2, 0.1]) { // Centers the text
        color(deboss_color)
        linear_extrude(0.5)  // Lower the text below the surface
        text(deboss_text, size=4.5, halign="center", valign="center");
    }
}