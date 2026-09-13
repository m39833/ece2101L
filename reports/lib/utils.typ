#let todo(body) = highlight(
  fill: yellow.lighten(70%),
  body,
)

#let callout(
  title: [Note],
  fill: blue.lighten(90%),
  inset: 10pt,
  body,
) = block(
  width: 100%,
  inset: inset,
  radius: 4pt,
  fill: fill,
)[
  *#title* \
  #body
]

#let eval-at(expr, lower, upper: none) = {
  if upper == none {
    $ lr(#expr |)_(#lower) $
  } else {
    $ lr(#expr |)_(#lower)^(#upper) $
  }
}

#let round(n, digits) = {
  calc.round(n, digits: digits)
}

#let round3(n) = {
  calc.round(n, digits: 3)
}

#let round2(n) = {
  calc.round(n, digits: 2)
}

#let boxed(body, inset: 5pt) = {
  let is-equation = (
    type(body) == content and body.func() == math.equation
  )

  let body = if is-equation {
    body
  } else {
    math.equation(
      block: false,
      body,
    )
  }

  rect(
    stroke: 0.8pt,
    inset: inset,
    body,
  )
}

// currently typst doesnt have a way to get the rendered height of equations
// workaround is to have presets for things like fractions to move/resize arrow
#let cancelto(
  target,
  body,
  h: auto,
  left: auto,
  down: auto,
  arrow-glyph: sym.arrow.r,
) = context {
  let contains-element(value, wanted) = {
    if type(value) == content {
      (
        value.func() == wanted
          or value
            .fields()
            .values()
            .any(child => contains-element(child, wanted))
      )
    } else if type(value) == array {
      value.any(child => contains-element(child, wanted))
    } else if type(value) == dictionary {
      value.values().any(child => contains-element(child, wanted))
    } else {
      false
    }
  }

  let has-frac = contains-element(body, math.frac)
  let auto-h = if has-frac { 2.3 } else { 1.25 }
  let auto-left = if has-frac { 5pt } else { 2pt }
  let auto-down = if has-frac { 4pt } else { 2pt }

  let h-value = if h == auto { auto-h } else { h }
  let left-value = if left == auto { auto-left } else { left }
  let down-value = if down == auto { auto-down } else { down }

  let measured-body = math.equation(
    block: false,
    body,
  )

  let body-size = measure(measured-body)

  let label = scale(
    x: 75%,
    y: 75%,
    reflow: true,
    target,
  )
  let label-size = measure(label)

  let body-w = body-size.width
  let body-h = body-size.height

  let overshoot-factor = 1.3
  let overshoot = overshoot-factor * 100%

  let base-run = calc.max(body-w * 0.9, 7pt)
  let base-rise = calc.max(
    body-h * h-value + label-size.height * 0.25,
    9pt,
  )

  let run = base-run + left-value / overshoot-factor
  let rise = base-rise + down-value / overshoot-factor
  let run-num = run / 1pt
  let rise-num = rise / 1pt

  let angle = calc.atan2(run-num, rise-num)

  let diagonal = (
    calc.sqrt(
      run-num * run-num + rise-num * rise-num,
    )
      * 1pt
  )

  let base = math.stretch(arrow-glyph, size: 100%)
  let base-width = measure(base).width

  let target-length = diagonal * overshoot
  let arrow-size = diagonal / base-width * overshoot

  let rough-arrow = math.stretch(
    arrow-glyph,
    size: arrow-size,
  )

  // correct for discrete sizes returned by math.stretch
  let rough-width = measure(rough-arrow).width
  let correction = target-length / rough-width * 100%

  let exact-arrow = scale(
    x: correction,
    y: 100%,
    reflow: true,
    rough-arrow,
  )

  let arrow = rotate(
    -angle,
    exact-arrow,
  )

  // compensating shifts to keep upper-right tip fixed
  let arrow-x = -body-w * 0.5 - left-value / 2
  let arrow-y = -body-h * 0.35 + down-value / 2

  let tip-x = (
    arrow-x + run * overshoot-factor / 2
  )
  let tip-y = (
    arrow-y - rise * overshoot-factor / 2
  )

  let tail-x = (
    arrow-x - run * overshoot-factor / 2
  )

  let left-reserve = calc.max(
    0pt,
    -body-w - tail-x,
  )

  let short-width = measure(
    box(width: 0.45em),
  ).width

  // let label-shift = if label-size.width > short-width {
  //   (label-size.width - short-width) / 2 + 3pt
  // } else {
  //   0pt
  // }
  let label-shift = (label-size.width - short-width) / 2 + 5pt

  let label-x = tip-x + label-shift
  let label-y = tip-y + 2pt

  let right-reserve = calc.max(
    0pt,
    label-x + label-size.width / 2,
  )

  set place(center + horizon)

  std.h(left-reserve)

  body

  place(
    center + horizon,
    dx: arrow-x,
    dy: arrow-y,
    arrow,
  )

  place(
    center + bottom,
    dx: label-x,
    dy: label-y,
    label,
  )

  std.h(right-reserve)
}
