offset = 8;
ren_det = 100;

difference()
{
  //the rim
  translate([0,0,0 - offset])
    cylinder(h = 25, r = 21, $fn = ren_det);
  //rear bead
  translate([0,0,1.5 - offset])
    difference()
    {
      cylinder(h = 4, r = 22);
      cylinder(h = 5, r1 = 21 - 2, r2 = 21 - 3, $fn = ren_det);
    }
  //front bead
  translate([0,0,25 - offset - 1.5 - 4])
    difference()
    {
      cylinder(h = 4, r = 22);
      cylinder(h = 5, r1 = 21 - 3, r2 = 21 - 2, $fn = ren_det);
    }
  //the middle
  translate([0,0,-1 - offset])
    cylinder(h = 27, r = 16, $fn = ren_det);
  //the rear chamfer
  translate([0,0,-1 - offset])
    /* arctan(1/4) is the angle of the bottom of the bead.
     tan of this times 6.5 gives the ammount ro make r1
     larger than r2 to maitain 1.5mm of rim. */
    cylinder(h = 6.5,
             r1 = 16 + (tan(atan( 1 / 4 )) * 6.5),
             r2 = 16,
             $fn = ren_det);
  //The front chamfer
  translate([0,0,19.5 - offset])
    cylinder(h = 6.5,
             r1 = 16,
             r2 = 16 + (tan(atan( 1 / 4 )) * 6.5),
             $fn = ren_det);
}
//The lip on the front of the rim
  difference()
  {
    translate([0,0,25 - offset])
      cylinder(h = 0.25, r = 21, $fn = ren_det);
    translate([0,0,24 - offset])
      cylinder(h = 2, r = 20, $fn = ren_det);
  }