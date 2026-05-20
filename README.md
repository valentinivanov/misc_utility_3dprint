# Car Cabin Convenience Hook

Parametric 3D-printable hooks for hanging clothing or clothes hangers inside a car cabin. The designs avoid drilling, adhesives, or permanent trim changes.

## Files

- `src/volvo_over_door_slot_hook.scad` - Volvo-style over-door slot hook source.
- `exports/volvo_over_door_slot_hook.stl` - generated over-door slot hook STL.
- `exports/volvo_over_door_slot_hook_preview.png` - over-door slot hook preview.

## Volvo-Style Over-Door Slot Hook Fit

Hook is universal: you can either hang clothes directly using the hook part, or use a proper hanger and hang it using the ring part.

Should fit default Volvo 8-like mount. In case if not fitting - measure the interior slot above the passenger door, then adjust these values in `src/volvo_over_door_slot_hook.scad`:

```scad
foundation_diameter = 20;
foundation_thickness = 5;

stem_diameter = 10;
```

## Recommended Print Settings

- Material: PETG, ASA, ABS, or nylon. Avoid PLA for hot car interiors.
- Perimeters/walls: 3 or more.
- Infill: 35-50%, gyroid or honeycomb.
- Layer height: 0.20 mm.
- Slot hook orientation: the hook is already oriented for best strength.
- Supports: Need supports for the round part. Try to play tree vs normal to get best results.

## Notes

This is a convenience hook, not a safety-critical mount. Keep the load light, keep it clear of airbags, seat belts, and driver visibility, and test fit gently before applying force.
Author waives any liability for any damage or inconvenience resulted by the hook usage. Use it on your own judgment.

To regenerate the STL:

```sh
openscad -o exports/volvo_over_door_slot_hook.stl src/volvo_over_door_slot_hook.scad
```
