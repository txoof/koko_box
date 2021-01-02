use <../finger_joint_box/finger_joint_box.scad>

/* [Card Dimensions] */
// Card Width
card_x = 40;
// Thickness of stacked cards
card_y = 65;
// Height of cards (mm)
card_z = 70;
//Extera space (mm) added to card dimensions to give more room
extra_space = 5;

/* [Construction Dimensions] */
// Material thickness (mm)
c_material = 3.2;
// Finger Width
c_finger  = 5;
//Percentage of total height for lid
c_lid_percent = 0.33;
//Number of internal dividers
/* c_dividers = 1; */
//Separation of 2D parts (multiple of thickness)
c_separation = 1;//[0.5:.1:3]

/* [Text] */
// Text to show on box
/* c_text = "Koko's Books"; */


/* [Display] */
//Use 2D or 3D layout
c_layout_2D = false;
//Transparency for 3D rendered box
c_alpha = 0.6;//[0.3:0.1:1]


/* [Hidden] */
c_dividers = 0;

external_x = card_x+2*c_material+extra_space;
external_y = card_y+2*c_material+extra_space;
external_z = card_z+2*c_material+extra_space;

size_top = [external_x, external_y, external_z*c_lid_percent];
size_bottom = [external_x, external_y, external_z*(1-c_lid_percent)];

separation = c_separation * c_material;

module scaled_text() {
  text_len = (external_x * 2 + external_y * 2)*.8;
  resize([text_len, 0], auto=true)
  text(c_text);
}


module test_block() {
  translate([0, 0, external_z/2])
  # cube([external_x, external_y, external_z], true);
}

module scale_box() {
  translate( [(size_top[0]*1.25+size_top[1]*2+separation*3)/2,
               -size_top[0]/4-separation-size_top[1]/2, 0 ]) {
    square([20, 10], center=true);
  }
}


module box_layout(size, material, layout_2D, dividers, separation) {
  if (layout_2D) {
    front = [0, 0, 0];
    back = [size[0]+separation, 0, 0];
    left = [back[0]+size[0]/2+size[1]/2+separation, 0, 0];
    right = [left[0]+size[1]+separation, 0, 0];
    top = [0, front[0]-size[2]/2-size[1]/2-separation, 0];

    // XZ face (front)
    translate(front) {
      color("Red")
      children(0);
    }

    // XZ face (back)
    translate(back) {
      color("darkred")
      children(1);
    }

    //XY face (top)
    translate(top) {
      color("lime")
      children(4);
    }

    //YZ face (left)
    translate(left) {
      color("blue")
      children(2);
    }

    translate(right) {
      color("darkblue")
      children(3);
    }

  } else {
    // amount to shift everything to account for material Thickness
    D = material/2;
    top = [0, 0, D];
    left = [-size[0]/2+D, 0, size[2]/2];
    right = [size[0]/2-D, 0, size[2]/2];
    front = [0, -size[1]/2+D, size[2]/2];
    back = [0, size[1]/2-D, size[2]/2];

    translate(top) {
      color("green", c_alpha)
      linear_extrude(height=material, center=true)
      children(4);
    }

    translate(left) {
      rotate([90, 0, 270])
      color("blue", c_alpha)
      linear_extrude(height=material, center=true)
      children(2);
    }
    translate(right) {
      rotate([90, 0, 90])
      color("darkblue", c_alpha)
      linear_extrude(height=material, center=true)
      children(3);
    }

    translate(front) {
      rotate([90, 0, 0])
      color("red", c_alpha)
      linear_extrude(height=material, center=true)
      children(0);
    }

    translate(back) {
      rotate([90, 0, 180])
      color("darkred", c_alpha)
      linear_extrude(height=material, center=true)
      children(1);
    }
  }
}
// layout the top of the box
module top() {
  p = 180/$t;
  t = c_layout_2D ? [0, 0, 0] : [0, 0, external_z];
  r = c_layout_2D ? [0, 0, 0] : [0, 180, 0];
  translate(t) {
    rotate(r)
    box_layout(size=size_top, material=c_material,
              layout_2D=c_layout_2D, dividers=c_dividers,
              separation=separation) {
      // front 0
      faceA(size=size_top, finger=c_finger, lidFinger=0, material=c_material,
        dividers=0);
      // back 1
      faceA(size=size_top, finger=c_finger, lidFinger=0, material=c_material,
          dividers=0);
      // left 2
      faceC(size=size_top, finger=c_finger, lidFinger=0, material=c_material);
      // right 3
      faceC(size=size_top, finger=c_finger, lidFinger=0, material=c_material);
      // top 4
      faceB(size=size_top, finger=c_finger, lidFinger=0, material=c_material, dividers=0);

    }
  }
}

module test_layout() {
  front = [0, 0, 0];
  right = [size_bottom[0]/2+size_bottom[1]/2-c_material, 0, 0];
  back = [right[0]+size_bottom[1]/2+size_bottom[0]/2-c_material, 0, 0];
  left = [back[0]+size_bottom[0]/2+size_bottom[1]/2-c_material, 0, 0];
  translate(front)
  color("red")
  children(0);
  translate(right)
  color("blue")
  children(3);
  translate(back)
  color("silver")
  children(1);
  translate(left)
  color("brown")
  children(2);
}

module bottom() {
  D = c_material;
  t = c_layout_2D ? [size_bottom[0]+size_bottom[1]*2+D*3, -size_top[2]/2-size_top[1]-size_bottom[0]/2-D*2, 0] : [0, 0, 0];
  r = c_layout_2D ? [0, 0, 180] : [0, 0, 0];

  f_text = [-size_bottom[0]/2+D, 0, 0];
  r_text = [-size_bottom[1]/2-size_bottom[0]+D+D, 0, 0];
  b_text = [-size_bottom[0]*1.5-size_bottom[1]+D+D+D, 0, 0];
  l_text = [-size_bottom[1]*1.5-size_bottom[0]*2+D+D+D+D, 0, 0];

  translate(t) {
    rotate(r)
    box_layout(size=size_bottom, material=c_material,
              layout_2D=c_layout_2D, dividers=c_dividers,
              separation=separation) {
    /* test_layout(size=size_bottom, material=c_material,
              layout_2D=c_layout_2D, dividers=c_dividers,
              separation=separation) { */

      //front
      difference() {
        faceA(size=size_bottom, finger=c_finger, lidFinger=0, material=c_material, dividers=0);
        /* translate([0, 0, 0]) */
        /* translate(f_text)
          scaled_text(); */

      }

      //back
      difference() {
        faceA(size=size_bottom, finger=c_finger, lidFinger=0, material=c_material, dividers=0);
        /* translate(b_text)
          scaled_text(); */
      }

      // left
      difference() {
        faceC(size=size_bottom, finger=c_finger, lidFinger=0, material=c_material);
        /* translate(l_text)
          scaled_text(); */
      }

      // right
      difference() {
        faceC(size=size_bottom, finger=c_finger, lidFinger=0, material=c_material);
        /* translate(r_text)
          scaled_text(); */
      }

      //top
      faceB(size=size_bottom, finger=c_finger, lidFinger=0,  material=c_material, dividers=0);



    }
  }
}
/* c_layout_2D = false; */



bottom();
top();
scale_box();
/* test_block(); */
