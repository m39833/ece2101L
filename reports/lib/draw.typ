#import "@preview/zap:0.6.0"
#import "constants.typ": annotation-blue, circuit-defaults

#import zap: cetz

#let is-terminal-anchor(anchor) = (
  type(anchor) == str
    and anchor.contains(".")
    and anchor.split(".").last() in ("in", "out")
)

#let same-component-terminals(start, end) = {
  if (
    is-terminal-anchor(start) and is-terminal-anchor(end)
  ) {
    let start-parts = start.split(".")
    let end-parts = end.split(".")

    (
      start-parts.first() == end-parts.first()
        and start-parts.last() != end-parts.last()
    )
  } else {
    false
  }
}

#let voltage-annotation(
  start,
  end,
  label: $v$,
  length: 1.8,
  offset: auto,
  side: "right",
  color: annotation-blue,
) = {
  let effective_voltage_offset = if offset != auto {
    offset
  } else if same-component-terminals(start, end) {
    8pt
  } else {
    0pt
  }

  cetz.draw.get-ctx(ctx => {
    let (
      ctx,
      guide-start,
      guide-end,
      length-vector,
      offset-vector,
    ) = cetz.coordinate.resolve(
      ctx,
      start,
      end,
      (length, 0),
      (effective_voltage_offset, 0),
      update: false,
    )

    let x0 = guide-start.at(0)
    let y0 = guide-start.at(1)
    let x1 = guide-end.at(0)
    let y1 = guide-end.at(1)

    let dx = x1 - x0
    let dy = y1 - y0
    let guide-length = calc.sqrt(dx * dx + dy * dy)

    assert(
      guide-length > 0,
      message: "voltage-annotation start and end must differ",
    )

    // start->end unit vector
    let ux = dx / guide-length
    let uy = dy / guide-length

    let annotation-length = calc.abs(
      length-vector.at(0),
    )

    let annotation-offset = calc.abs(
      offset-vector.at(0),
    )

    let side-factor = if side == "right" {
      1
    } else if side == "left" {
      -1
    } else {
      panic(
        "voltage-annotation side must be \"left\" or \"right\"",
      )
    }

    // normal unit vector
    let nx = side-factor * uy
    let ny = side-factor * -ux

    let guide-cx = (x0 + x1) / 2
    let guide-cy = (y0 + y1) / 2

    // shift entire annotation away from the component
    let cx = guide-cx + nx * annotation-offset
    let cy = guide-cy + ny * annotation-offset

    let half-length = annotation-length / 2

    // position positive terminal toward start
    let plus-position = (
      cx - ux * half-length,
      cy - uy * half-length,
    )

    let label-position = (cx, cy)

    let minus-position = (
      cx + ux * half-length,
      cy + uy * half-length,
    )

    cetz.draw.content(
      plus-position,
      text(fill: color)[$+$],
      anchor: "center",
    )

    cetz.draw.content(
      label-position,
      text(fill: color)[#label],
      anchor: "center",
    )

    cetz.draw.content(
      minus-position,
      text(fill: color)[$-$],
      anchor: "center",
    )
  })
}

#let current-annotation(
  start,
  end,
  label: $i$,
  length: 1.25,
  arrow_offset: auto,
  current_label_offset: circuit-defaults.label.distance,
  side: "right",
  color: annotation-blue,
) = {
  let effective_arrow_offset = if arrow_offset != auto {
    arrow_offset
  } else if same-component-terminals(start, end) {
    circuit-defaults.label.distance + 3pt
  } else {
    0pt
  }

  cetz.draw.get-ctx(ctx => {
    // Resolve coordinates, including named anchors.
    // Resolving (length, 0) also converts Typst lengths such
    // as 8pt into the current CeTZ coordinate system.
    let (
      ctx,
      guide-start,
      guide-end,
      length-vector,
      arrow-offset-vector,
      label-offset-vector,
    ) = cetz.coordinate.resolve(
      ctx,
      start,
      end,
      (length, 0),
      (effective_arrow_offset, 0),
      (current_label_offset, 0),
      update: false,
    )

    let x0 = guide-start.at(0)
    let y0 = guide-start.at(1)
    let x1 = guide-end.at(0)
    let y1 = guide-end.at(1)

    let dx = x1 - x0
    let dy = y1 - y0
    let guide-length = calc.sqrt(dx * dx + dy * dy)

    assert(
      guide-length > 0,
      message: "current-arrow start and end must be different",
    )

    // Perpendicular normal. "right" matches the reference:
    // a downward arrow has its label on the page's left.
    let side-factor = if side == "right" {
      1
    } else if side == "left" {
      -1
    } else {
      panic("current-arrow side must be \"left\" or \"right\"")
    }

    let ux = dx / guide-length
    let uy = dy / guide-length
    let nx = side-factor * uy
    let ny = side-factor * -ux

    let arrow-length = calc.abs(length-vector.at(0))
    let arrow-offset = calc.abs(arrow-offset-vector.at(0))
    let label-offset = calc.abs(label-offset-vector.at(0))

    let guide-cx = (x0 + x1) / 2
    let guide-cy = (y0 + y1) / 2

    let arrow-cx = guide-cx + nx * arrow-offset
    let arrow-cy = guide-cy + ny * arrow-offset

    let half-length = arrow-length / 2

    let arrow-start = (
      arrow-cx - ux * half-length,
      arrow-cy - uy * half-length,
    )

    let arrow-end = (
      arrow-cx + ux * half-length,
      arrow-cy + uy * half-length,
    )

    let label-position = (
      arrow-cx + nx * label-offset,
      arrow-cy + ny * label-offset,
    )

    // anchor the label by the edge facing the arrow
    let label-anchor = calc.atan2(-nx, -ny)

    cetz.draw.line(
      arrow-start,
      arrow-end,
      stroke: color + 0.8pt,
      mark: (
        end: ">",
        fill: color,
        stroke: color,
        length: 0.25,
        width: 0.14,
      ),
    )

    cetz.draw.content(
      label-position,
      text(fill: color)[#label],
      anchor: label-anchor,
    )
  })
}


#let circular-current(
  name,
  center,
  label: $i$,
  direction: "cw",
  spacing: 1em,
  sweep: 270deg,
  gap_angle: 180deg,
  color: annotation-blue,
  thickness: 0.8pt,
  arrow_length: 0.25,
  arrow_width: 0.14,
) = {
  assert(
    direction in ("cw", "ccw"),
    message: "direction must be \"cw\" or \"ccw\"",
  )

  assert(
    sweep > 0deg and sweep < 360deg,
    message: "sweep must be between 0deg and 360deg",
  )

  let label-name = name + "-label"
  let styled-label = text(fill: color)[#label]

  // Draw and name the label first so its anchors are available.
  cetz.draw.content(
    center,
    styled-label,
    anchor: "center",
    name: label-name,
  )

  cetz.draw.get-ctx(ctx => {
    let (
      ctx,
      label-center,
      label-east,
      label-west,
      label-north,
      label-south,
      spacing-vector,
    ) = cetz.coordinate.resolve(
      ctx,
      label-name + ".center",
      label-name + ".east",
      label-name + ".west",
      label-name + ".north",
      label-name + ".south",
      (spacing, 0),
      update: false,
    )

    let distance(a, b) = {
      let dx = a.at(0) - b.at(0)
      let dy = a.at(1) - b.at(1)
      calc.sqrt(dx * dx + dy * dy)
    }

    let half-width = (
      distance(
        label-east,
        label-west,
      )
        / 2
    )

    let half-height = (
      distance(
        label-north,
        label-south,
      )
        / 2
    )

    // Bounding-circle radius of the label.
    let label-radius = calc.sqrt(
      half-width * half-width + half-height * half-height,
    )

    let label-gap = calc.abs(
      spacing-vector.at(0),
    )

    let radius = label-radius + label-gap

    // Keep the opening centered around gap_angle.
    let gap-size = 360deg - sweep
    let half-gap = gap-size / 2

    let start-angle = if direction == "ccw" {
      gap_angle + half-gap
    } else {
      gap_angle - half-gap
    }

    let delta-angle = if direction == "ccw" {
      sweep
    } else {
      -sweep
    }

    cetz.draw.arc(
      label-center,
      radius: radius,
      start: start-angle,
      delta: delta-angle,
      anchor: "origin",
      stroke: color + thickness,
      mark: (
        end: ">",
        fill: color,
        stroke: color,
        length: arrow_length,
        width: arrow_width,
      ),
    )
  })
}
