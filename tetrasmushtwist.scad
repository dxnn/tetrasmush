edgeLength = 4; // smallest tetra
smushexp = 0.9; // printers need overlap
smushdelta = 1; // fine detail overlap
iterations = 5; // double the height
twist = 1.0;    // give it a twist
hulls = 1;      // smear across space
convx = 0;      // cancave underbelly

quad([0,0,0], edgeLength, iterations);

module quad(t, l, count) { // toppoint and length
  rendtetra(t, l);
  
  count = count - 1;
  if(count >= 0) {
    vs = tet(t, l*2^(count*smushexp) - smushdelta);
    quad(vs[0], l, count);
    quad(vs[1], l, count);
    quad(vs[2], l, count);
    quad(vs[3], l, count);  
  } 
}

module rendtetra(t, l) { // toppoint and length
  if(hulls) {
    hull() {
      rotate(twist * t.z)
        polyhedron(tet(t, l), [[0,2,1], [0,1,3], [1,2,3], [0,3,2]]);
      polyhedron(tet(t, l), [[0,2,1], [0,1,3], [1,2,3], [0,3,2]]);
    }
  } 
  
  else if (convx) {
    tt = tet(t, l);
    p = [tt[0].x, tt[0].y, tt[0].z - sqrt(l^2 - (sqrt(3)/3 * l)^2)*0.9];
    rotate(twist * t.z)
      polyhedron([tt[0], tt[1], tt[2], tt[3], p], [[0,2,1], [0,1,3], [0,3,2], [1, 2, 4], [2, 3, 4], [3, 1, 4]]); // concave bottom for better bridging
  }
      
  else {
    rotate(twist * t.z)
      polyhedron(tet(t, l), [[0,2,1], [0,1,3], [1,2,3], [0,3,2]]);
  }
}

function tet(t, l) = // get the four corner points
  let (h = sqrt(l^2 - (sqrt(3)/3 * l)^2), // height
       r = l / sqrt(3), // radius
       bh = t[2] - h)   // base height
    [ t,
     [t.x + r,   t.y,       bh],
     [t.x - r/2, t.y + l/2, bh],
     [t.x - r/2, t.y - l/2, bh]];
