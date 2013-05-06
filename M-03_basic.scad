include <MCAD/shapes.scad>

//Settings
offset = -1.5;
ren_det = 100;
face_radius = 180;


wheel_rim(lip = false);
hub(nut_guide = false);


/* Punch the middle out of the part we'll cut the spokes into with
 this difference. */
difference()
{
  union()
  {
    /* make a face with a radius that we can cut spokes into later. 
     The amount to pull the big sphere down is the root of; the square
     of the radius of the shpere minus the square of the radius of the
     cylinder. See chords. */
    intersection()
    {
      translate([0,0,12 - offset])
        cylinder(r = 21, h = 5, $fn = ren_det);
      translate([0,0,12.5 - sqrt(pow(face_radius,2) - pow(21,2)) - offset])
        sphere(r = face_radius, $fn = ren_det * 4);
    }
    //the lower portion of the face
    cylinder(r = 18, h = 12.5 - offset, $fn = ren_det);
  }
  //clear the hex
  translate([0,0,-1])
    cylinder(r = 9.25, h = 7.5, $fn = ren_det);
  //cut for the tool whoose diameter needs 5.5mm
  translate([0,0,5])
    cylinder(r = 5.5, h = 25, $fn = ren_det);
  /* Use a series of cones to bevel the "tool hole", this is the first
   feature of the face that needs to obey offset. It's upper limit is
   the difference between the face's big shpere's radius and z
   position. */
  for(i = [0 : 50 / ren_det : 5])
  {
    translate([0,0,0 - sqrt(pow(face_radius,2) - pow(21,2)) + face_radius - offset + 7.5 + i])
      cylinder(r1 = 5.5, r2 = 5.5 + i, h = 5 - i, $fn = ren_det / 2);
  }
}


/////////////////////////////////////////////////////
//Modules


//The wheel rim is ther outer edge of the wheel
module wheel_rim(lip = true)
{
  difference()
  {
    //the rim
    translate([0,0,-12.5 - offset])
      cylinder(h = 25, r = 21, $fn = ren_det);
    //rear bead
    translate([0,0,-11 - offset])
      difference()
      {
        cylinder(h = 4, r = 22);
        cylinder(h = 5, r1 = 21 - 2, r2 = 21 - 3, $fn = ren_det);
      }
    //front bead
    translate([0,0,7 - offset])
      difference()
      {
        cylinder(h = 4, r = 22);
        cylinder(h = 5, r1 = 21 - 3, r2 = 21 - 2, $fn = ren_det);
      }
    //the middle
    translate([0,0,-13.5 - offset])
      cylinder(h = 27, r = 16, $fn = ren_det);
    //the rear chamfer
    translate([0,0,-13.5 - offset])
      /* arctan(1/4) is the angle of the bottom of the bead.
       tan of this times 6.5 gives the ammount ro make r1
       larger than r2 to maitain 1.5mm of rim. */
      cylinder(h = 6.5,
               r1 = 16 + (tan(atan( 1 / 4 )) * 6.5),
               r2 = 16,
               $fn = ren_det);
    //The front chamfer
    translate([0,0,7 - offset])
      cylinder(h = 6.5,
               r1 = 16,
               r2 = 16 + (tan(atan( 1 / 4 )) * 6.5),
               $fn = ren_det);
    //breather hole
    translate([-22,0,offset - 1.5])
      rotate([0,90,0])
        cylinder(r = 1, h = 7, $fn = ren_det / 10);
  }
  //The lip on the front of the rim
  if (lip)
  {
    difference()
    {
      translate([0,0,12.5 - offset])
        cylinder(h = 0.25, r = 21, $fn = ren_det);
      translate([0,0,11.5 - offset])
        cylinder(h = 2, r = 20, $fn = ren_det);
    }
  }
}

//The hub is the centre including the hex drive
module hub(nut_guide = true)
{
  //lower half with hex
  difference()
  {
    cylinder(r = 9.25, h = 6, $fn = ren_det / 2);
    hexagon(height = 13, size = 12.8);
  }
  //upper half with bore
  difference()
  {
    translate([0,0,6])
      cylinder(r = 9.25, h = 1.5, $fn = ren_det / 2);
    translate([0,0,5])
      cylinder(r = 2, h = 3, $fn = ren_det / 4);
  }
  if (nut_guide)
  {
    difference()
    {
      translate([0,0,7.5])
        cylinder(r = 10.25 / 2 + 1, h = 0.5, $fn = ren_det / 2);
      translate([0,0,7])
        cylinder(r = 10.25 / 2, h = 2, $fn = ren_det / 2);
    }
  }
}