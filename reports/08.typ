#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *
#import "@preview/zero:0.7.1": num
#import "@preview/cetz:0.4.2": canvas, draw


#show: report.with(
  title: [Lab 8: Power Analysis: Part 2],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "October 12, 2026",
  report-date: "October 26, 2026",
)

= No 1.

=== Step 1. The power triangle that characterizes the impedance in a circuit is shown below. In its simplest form, what does the impedance consist of?

#align(center)[
  #v(1em)
  #canvas({
    import draw: *

    // Triangle vertices
    let A = (0, 0)
    let B = (0, 2)
    let C = (7.5, 2)

    // Triangle sides
    line(A, B, stroke: 1pt)
    line(B, C, stroke: 1pt)
    line(A, C, stroke: 1pt)

    // Side labels
    content((-0.5, 1), [$Q$])
    content((3.5, 2.5), [$P$])
    content((3.8, 0.4), [$abs(vbold(S))$])

    // Angle arc at C
    arc(
      (4.5, 2),
      radius: 2.5,
      start: 180deg,
      stop: 198deg,
      stroke: 0.9pt,
    )

    // Angle label
    content((4, 1.5), [$theta_("pf")$])
  })
  #v(1em)
]

The impedance consists of some (positive) resistance and some (negative) reactance. Thus, a simplest equivalent model is a resistor and capacitor in series, because the circuit absorbs real power and has negative reactive power.

= No 2.

#align(center)[
  #zap.circuit({
    import zap: *
    import cetz.draw: content, line
    cetz.draw.set-style(zap: circuit-defaults)

    vsource("", (-3, -2.5), (-3, 2.5), label: (
      content: $250 angle 0degree "V"\ "   "("rms")$,
      anchor: "south",
    ))
    wire((-3, 2.5), (-1, 2.5))
    wire((-3, -2.5), (-1, -2.5))
    node("", (-1, 2.5))
    node("", (-1, -2.5))
    resistor("", (-1, 2.5), (2.5, 2.5), label: $qty("1", "ohm")$)
    inductor("", (2.5, 2.5), (6, 2.5), label: $j qty("4", "ohm")$)
    node("", (6, 2.5))
    node("", (6, -2.5))
    wire((6, 2.5), (8, 2.5))
    wire((6, -2.5), (8, -2.5))
    wire((-1, -2.5), (6, -2.5))
    resistor("", (8, 2.5), (8, 0), label: (
      content: $qty("39", "ohm")$,
      anchor: "south",
    ))
    inductor("", (8, 0), (8, -2.5), label: (
      content: $j qty("26", "ohm")$,
      anchor: "south",
    ))
    voltage-annotation((6, 2.5), (6, -2.5), length: 10em, label: $vbold(V)_(L)$)
    circular-current("I_L", (2.5, 0), spacing: 2em, label: $vbold(I)_(L)$)

    let y = -2.8
    let x1 = -1
    let x2 = 6.0

    line((-3, y), (8.0, y))
    line((x1, y - 0.15), (x1, y + 0.15))
    line((x2, y - 0.15), (x2, y + 0.15))

    content((-2, y - 0.35), [Source])
    content((2.5, y - 0.35), [Line])
    content((7.0, y - 0.35), [Load])
  })
]

=== Step 1. Find the phasor voltage $vbold(V)_(L)$ and current $vbold(I)_(L)$ for the load.

$
  Z_("eq") & = Z_("line") + Z_("load") \
           & = (1 + j 4) + (39 + j 26 ) \
           & = 40 + j qty("30", "ohm")
$

$
  vbold(V)_(L) = (250angle 0degree )(Z_("load")/(Z_("load") + Z_("line") ) )\
  boxed(vbold(V)_(L) = 234 - j qty("13", "V") = 234.36 angle -3.18degree "V")
$

$
  vbold(I)_(L) = vbold(V)_(L)/Z_("load") \
  boxed(vbold(I)_(L) = 5 angle -36.87degree "A" = 4-j 3 thin "A")
$

=== Step 2. Show that the power in the circuit balances.

$
  sum vbold(S) = vbold(S)_(s) + vbold(S)_("line") + vbold(S)_("load") \
$

$
       vbold(S)_(s) & = -vbold(V)_(s)vbold(I)_(L)^(*) = -1000 - j 750 "VA" \
  vbold(S)_("line") & = |vbold(I)_(L)|^2Z_("line") = 25 + j 100 "VA" \
  vbold(S)_("load") & = |vbold(I)_(L)|^2Z_("load") = 975 + j 650 "VA"
$

the source is delivering power, so its power is negative:
$
  sum vbold(S) = -(1000 + j 750) + (25 + j 100) + (975 + j 650) \
  boxed(sum vbold(S) = 0 quad checkmark, inset: #.8em)
$

=== Step 3. Use PSpice to simulate the circuit to confirm your results in Steps 1 and 2.

Assuming $f = 60 "Hz"$,

$
  X_(L) = omega L quad => quad L = X_(L)/(2pi f) quad => quad L_("line") = 4/(2pi 60), quad L_("load") = 26/(2pi 60)
$

#code-link(8, 2)
#align(center)[
  #block(
    width: 80%,
    fill: rgb("#1e1e1e"),
    radius: 6pt,
    inset: 12pt,
  )[
    #set align(left)
    #set text(fill: rgb("#cdd6f4"), size: 10pt)
    #set raw(theme: none)

    ```
    V_L: 234.00 -13.00j V = 234.36 ∠ -3.18° V
    I_L: 4.00 -3.00j A = 5.00 ∠ -36.87° A
    S_s (absorbed): -1000.00 -750.00j VA
    S_line: 25.00 +100.00j VA
    S_load: 975.00 +650.00j VA
    Power balance: 0.00 +0.00j VA
    ```
  ]
]

= No 3.

=== Step 1. A load requires a voltage of $qty("240", "V")$ (rms), absorbs $qty("8", "kW")$ and has a power factor of $0.8$ lagging. Find the complex power of the load.

$
  vbold(V) = 240 angle 0degree "(rms)", quad P = qty("8000", "W"), quad "pf" = 0.8 "lagging"
$

$
  phi = cos^(-1)("pf") => phi = 36.87degree \
  Q = 8000 tan(phi) => Q =6000 "VAR"
$

$
  => boxed(vbold(S) = 8000 + j 6000 "VA")
$

=== Step 2. Find the load impedance.

$
  vbold(S) = vbold(V)vbold(I)^(*) = vbold(V)(vbold(V)/Z)^(*) = vbold(V) vbold(V)^(*) /Z^(*) = (|vbold(V)|^2 )/Z^(*) \
  Z^(*) = (|vbold(V)|^2 )/vbold(S) \
  Z = (|vbold(V)|^2 )/vbold(S)^(*) \
  boxed(Z = 576/125 + j 432/125 thin Omega = 5.76 angle 36.87degree thin Omega, inset: #0.8em)
$

=== Step 3. Estimate the circuit configuration.

#align(center)[
  #zap.circuit({
    import zap: *
    cetz.draw.set-style(zap: circuit-defaults)

    vsource(
      "",
      (-1.5, -1.5),
      (-1.5, 1.5),
      label: (content: $240 angle 0degree "(rms)"$, anchor: "south"),
    )
    resistor("", (-1.5, 1.5), (3, 1.5), label: $576\/qty("125", "ohm")$)
    inductor("", (3, 1.5), (3, -1.5), label: $j 432\/qty("125", "ohm")$)
    wire((-1.5, -1.5), (3, -1.5))
  })
]

=== Step 4. Simulate your findings and confirm the results in Steps 1-3.

assuming $f = 60 "Hz"$,
$
  L = (432\/125)/(2pi 60) approx qty("9.167", "mH")
$

#code-link(8, 3)
#align(center)[
  #block(
    width: 80%,
    fill: rgb("#1e1e1e"),
    radius: 6pt,
    inset: 12pt,
  )[
    #set align(left)
    #set text(fill: rgb("#cdd6f4"), size: 10pt)
    #set raw(theme: none)

    ```
    Inductance = 9.167 mH
    Voltage = 240.00 V (rms)
    Current = 33.333 -25.000j A
    |Current| = 41.667 A (rms)
    Current phase relative to voltage = -36.87 degrees
    Complex power = 8000.00 +6000.00j VA
    Impedance = 4.608 +3.456j ohm
    Power factor = 0.800
    ```
  ]
]
