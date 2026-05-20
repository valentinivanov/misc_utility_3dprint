/*
  Volvo-style over-door slot hook geometry

  Shape definition:
  - Foundation: disk, 20 mm diameter, 5 mm thickness.
  - Stem: composite 60 mm post. The lower 15 mm is a 10 mm diameter cylinder;
    the upper section is a 10 x 10 mm square bar.
  - Two side rings: each ring is a flat washer-style ring, 35 mm outer diameter
    and 15 mm inner diameter.
  - The side rings are rotated so their ring planes are normal to the
    foundation face.
  - The side rings are mirrored left/right around the stem and positioned near
    the stem's free end.

  Units: millimeters
*/

include <BOSL2/std.scad>

$fn = 96;

foundation_diameter = 20;
foundation_thickness = 5;

stem_diameter = 10;
stem_length = 60;
stem_lower_cylinder_length = 25;
stem_bar_size_x = 10;
stem_bar_size_y = 15;
stem_bar_length = stem_length - stem_lower_cylinder_length;
stem_bar_length_correction = 4;
stem_bar_rounding = 1.0;
stem_bar_negative_y_face_edge_rounding = 5;
stem_bar_and_cylinder_overlap = 3;

side_ring_outer_diameter = 35;
side_ring_inner_diameter = 15;
side_ring_thickness = 10;
side_ring_chamfer = 1.0;

side_ring_outer_radius = side_ring_outer_diameter / 2;
side_ring_inner_radius = side_ring_inner_diameter / 2;

// Ring center measured from the top face of the foundation.
side_ring_center_from_foundation = 2 + stem_length  - foundation_thickness;

// Left/right offset of each ring center from the stem centerline.
side_ring_center_offset = side_ring_inner_diameter;

// Removed section on the positive-X side ring. Angles are in the ring plane:
// 0 degrees points outward on +X, 90 degrees points up, 180 degrees points
// inward toward the stem. The default gap starts near the upper stem/ring
// intersection.
right_ring_gap_start_degrees = 105;
right_ring_gap_span_degrees = 53;
right_ring_arc_segments = 96;

// Print orientation: rotate the finished model so its positive-Y side lies on
// the build plate, then center it along the resulting Y axis.
max_positive_y_extent = max(
  foundation_diameter / 2,
  stem_diameter / 2,
  -stem_diameter / 2 + stem_bar_size_y,
  stem_bar_size_y - side_ring_thickness / 2
);
model_length = foundation_thickness + side_ring_center_from_foundation + side_ring_outer_radius;

negative_y_face_edges = [
  FWD + LEFT,
  FWD + RIGHT,
  FWD + TOP,
  FWD + BOT
];

module foundation() {
  cylinder(
    h = foundation_thickness,
    d = foundation_diameter
  );
}

module stem_lower_cylinder() {
  translate([0, 0, foundation_thickness])
    cyl(
      h = stem_lower_cylinder_length,
      d = stem_diameter,
      center = false
    );
}

module stem_upper_bar() {
  translate([
    0,
    -stem_diameter / 2 + stem_bar_size_y / 2,
    foundation_thickness + stem_lower_cylinder_length + stem_bar_length / 2 - stem_bar_length_correction -stem_bar_and_cylinder_overlap
  ])
    intersection() {
      cuboid(
        [stem_bar_size_x, stem_bar_size_y, stem_bar_length - stem_bar_length_correction],
        rounding = stem_bar_rounding,
        except_edges = negative_y_face_edges
      );
      cuboid(
        [stem_bar_size_x, stem_bar_size_y, stem_bar_length - stem_bar_length_correction],
        rounding = stem_bar_negative_y_face_edge_rounding,
        edges = negative_y_face_edges
      );
    }
}

module stem() {
  union() {
    stem_lower_cylinder();
    stem_upper_bar();
  }
}

function arc_points(radius, start_degrees, span_degrees, steps) =
  [
    for (i = [0 : steps])
      let(a = start_degrees + span_degrees * i / steps)
        [radius * cos(a), radius * sin(a)]
  ];

module chamfered_ring() {
  tube(
    h = side_ring_thickness,
    od = side_ring_outer_diameter,
    id = side_ring_inner_diameter,
    chamfer = side_ring_chamfer,
    center = true
  );
}

module ring_gap_cutter() {
  cutter_radius = side_ring_outer_radius + 2;

  linear_extrude(height = side_ring_thickness + 4, center = true)
    polygon(concat(
      [[0, 0]],
      arc_points(cutter_radius, right_ring_gap_start_degrees, right_ring_gap_span_degrees, right_ring_arc_segments)
    ));
}

module right_open_ring() {
  difference() {
    chamfered_ring();
    ring_gap_cutter();
  }
}

module side_ring_right() {
  translate([side_ring_center_offset, stem_bar_size_y - side_ring_thickness, foundation_thickness + side_ring_center_from_foundation])
    rotate([90, 0, 0])
      right_open_ring();
}

module side_ring_left() {
  translate([-side_ring_center_offset, stem_bar_size_y - side_ring_thickness, foundation_thickness + side_ring_center_from_foundation])
    rotate([90, 0, 0])
      chamfered_ring();
}

module model_geometry() {
  union() {
    foundation();
    stem();
    side_ring_right();
    side_ring_left();
  }
}

module print_part() {
  translate([0, -model_length / 2, max_positive_y_extent])
    rotate([-90, 0, 0])
      model_geometry();
}

print_part();
