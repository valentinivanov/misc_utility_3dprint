/*
  Cup caddy geometry

  Shape definition:
  - Two chamfered rings for holding cups.
  - Each ring has an 81 mm inner diameter and a 101 mm outer diameter.
  - Rings are positioned side by side with 40 mm clear space between them.
  - Two chamfered 10 x 10 mm connector rails run from X = -70 mm to X = 70 mm.
  - One chamfered contra-rail runs from Y = -50 mm to Y = 50 mm at X = 0.
  - One center rail runs from X = -25 mm to X = 25 mm at Y = 0.
  - One rounded 20 x 20 mm top rail sits 120 mm above the base.
  - Two center braces support the top rail from the base.

  Units: millimeters
*/

include <BOSL2/std.scad>

$fn = 128;

ring_inner_diameter = 81;
ring_outer_diameter = 101;
ring_thickness = 10;
ring_chamfer = 1;
ring_spacing = 40;

ring_center_spacing = ring_outer_diameter + ring_spacing;
connector_width = 10;
connector_height = 10;
connector_start_x = -70;
connector_end_x = 70;
connector_length = connector_end_x - connector_start_x;
connector_center_x = (connector_start_x + connector_end_x) / 2;
connector_y_offset = (ring_outer_diameter - connector_width) / 2;
contra_rail_start_y = -50;
contra_rail_end_y = 50;
contra_rail_length = contra_rail_end_y - contra_rail_start_y;
contra_rail_center_y = (contra_rail_start_y + contra_rail_end_y) / 2;
center_rail_start_x = -25;
center_rail_end_x = 25;
center_rail_length = center_rail_end_x - center_rail_start_x;
center_rail_center_x = (center_rail_start_x + center_rail_end_x) / 2;
top_rail_z = 120;
center_brace_attachment_y_positions = [-7, 7];
center_brace_top_attachment_y_positions = [-72, 72];
top_rail_width = 20;
top_rail_height = 20;
top_rail_rounding = 2 * ring_chamfer;
top_rail_start_y = -80;
top_rail_end_y = 80;
top_rail_length = top_rail_end_y - top_rail_start_y;
top_rail_center_y = (top_rail_start_y + top_rail_end_y) / 2;

module chamfered_ring() {
  tube(
    h = ring_thickness,
    od = ring_outer_diameter,
    id = ring_inner_diameter,
    chamfer = ring_chamfer,
    center = true
  );
}

module connector_rails() {
  for (y = [-connector_y_offset, connector_y_offset])
    translate([connector_center_x, y, 0])
      cuboid(
        [connector_length, connector_width, connector_height],
        chamfer = ring_chamfer
      );
}

module contra_rail() {
  translate([0, contra_rail_center_y, 0])
    cuboid(
      [connector_width, contra_rail_length, connector_height],
      chamfer = ring_chamfer
    );
}

module center_rail() {
  translate([center_rail_center_x, 0, 0])
    cuboid(
      [center_rail_length, connector_width, connector_height],
      chamfer = ring_chamfer
    );
}

module top_rail() {
  translate([0, top_rail_center_y, top_rail_z])
    cuboid(
      [top_rail_width, top_rail_length, top_rail_height],
      rounding = top_rail_rounding
    );
}

module diagonal_rail(start_point, end_point) {
  rail_vector = end_point - start_point;

  translate((start_point + end_point) / 2)
    cuboid(
      [connector_width, connector_width, norm(rail_vector)],
      chamfer = ring_chamfer,
      orient = rail_vector
    );
}

module diagonal_braces() {
  for (i = [0 : 1]) {
    center_brace_start = [0, center_brace_attachment_y_positions[i], 0];
    center_brace_end = [0, center_brace_top_attachment_y_positions[i], top_rail_z];

    diagonal_rail(
      center_brace_start,
      center_brace_end
    );
  }
}

module cup_caddy() {
  union() {
    for (x = [-ring_center_spacing / 2, ring_center_spacing / 2])
      translate([x, 0, 0])
        chamfered_ring();

    connector_rails();
    contra_rail();
    center_rail();
    top_rail();
    diagonal_braces();
  }
}

cup_caddy();
