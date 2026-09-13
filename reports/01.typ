#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *

#show: report.with(
  title: [Lab 1: First-Order (RL/RC) Circuits],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "August 24, 2026",
  report-date: "September 2, 2026",
)

= No. 1

=== Step 1. Find $v_(o)(t)$ for $t>=0^(+)$

#let before = zap.circuit({
  import zap: *

  cetz.draw.set-style(zap: circuit-defaults)

  isource(
    "source",
    (0, 0),
    (0, 3),
    label: (
      content: $qty("6.4", "A")$,
      anchor: "north",
    ),
  )

  wire((0, 3), (2.2, 3))
  wire((0, 0), (5.8, 0))

  resistor(
    "r10",
    (2.2, 3),
    (2.2, 0),
    label: (
      content: $qty("10", "ohm")$,
      anchor: "south", // left side for a downward component
    ),
  )

  // Voltage polarity annotation
  cetz.draw.content(
    (2.75, 2.65),
    text(fill: annotation-blue)[$+$],
    anchor: "center",
  )
  cetz.draw.content(
    (2.75, 1.5),
    text(fill: annotation-blue)[$v_(o)$],
    anchor: "center",
  )
  cetz.draw.content(
    (2.75, 0.35),
    text(fill: annotation-blue)[$-$],
    anchor: "center",
  )

  resistor(
    "r6",
    (2.2, 3),
    (5.8, 3),
    label: $qty("6", "ohm")$,
  )

  // inductor(
  //   "l1",
  //   (5.8, 3),
  //   (5.8, 0),
  //   label: (
  //     content: $0.32 upright(H)$,
  //     anchor: "south",
  //   ),
  // )
  wire((5.8, 3), (5.8, 0))

  // wire((5.8, 3), (8.4, 3))

  // resistor(
  //   "r4",
  //   (8.4, 3),
  //   (8.4, 0),
  //   label: (
  //     content: $4 Omega$,
  //     anchor: "south",
  //   ),
  // )

  node("a", (2.2, 3))
  node("b", (2.2, 0))
  // node("c", (5.8, 3))
  // node("d", (5.8, 0))
})

#let after = zap.circuit({
  import zap: *

  cetz.draw.set-style(zap: circuit-defaults)

  wire((0, 0), (6.2, 0))

  resistor(
    "r10-after",
    (0, 3),
    (0, 0),
    label: (
      content: $qty("10", "ohm")$,
      anchor: "south",
    ),
  )

  // Same voltage reference after switching
  cetz.draw.content(
    (0.55, 2.65),
    text(fill: annotation-blue)[$+$],
    anchor: "center",
  )
  cetz.draw.content(
    (0.55, 1.5),
    text(fill: annotation-blue)[$v_(o)$],
    anchor: "center",
  )
  cetz.draw.content(
    (0.55, 0.35),
    text(fill: annotation-blue)[$-$],
    anchor: "center",
  )

  resistor(
    "r6-after",
    (0, 3),
    (3.6, 3),
    label: $qty("6", "ohm")$,
  )

  inductor(
    "l-after",
    (3.6, 3),
    (3.6, 0),
    label: (
      content: $qty("0.32", "H")$,
      anchor: "north",
    ),
  )

  wire((3.6, 3), (6.2, 3))

  resistor(
    "r4-after",
    (6.2, 3),
    (6.2, 0),
    label: (
      content: $qty("4", "ohm")$,
      anchor: "north",
    ),
  )

  // node("a-after", (0, 3))
  // node("b-after", (0, 0))
  node("c-after", (3.6, 3))
  node("d-after", (3.6, 0))
})

// #move(dx: 1em)[
#scale(95%, reflow: false)[
  #grid(
    columns: (auto, 0pt, auto),
    column-gutter: 6em,
    align: center + horizon,

    align(center)[
      #v(0.7em)
      #before
      #move(dx: 2em)[$t = 0^(-)$]
    ],

    // h(2em),
    align(center)[
      // $t = 0$
      // #v(1pt)
      #text(size: 24pt)[$arrow.r.long$]
    ],

    align(center)[
      #v(0.7em)
      #after
      $t = 0^(+)$
    ],
  )
]
// ]

#v(2em)
for $t=0^(-)$ :
$
  10parallel 6 = qty("3.75", "ohm")\
  v_(o)(0^(-) ) = 6.4(3.75) = qty("24", "V")\
  i_(L) (0^(-) ) = 24/6 = qty("4", "A")
$

for $t > 0$ :
$
  i_(L)(0^(+) ) = i_(L)(0^(-) ) = qty("4", "A")\
  R_("eq") = 4 parallel (10 + 6) = qty("3.2", "ohm")\
  tau = L/R_("eq") = 0.32/3.2 = qty("0.1", "s") \
$
Note that $i_(L) (oo) = 0$ for natural response
$
  i_(L)(t) = cancelto(0, i_(L)(oo)) + [i_(L)(0^(+)) - cancelto(0, i_(L)(oo))]e^(-t\/tau)\
  i_(L)(t) = i_(L)(0^(+))e^(-t\/tau)\
  boxed(i_(L)(t) = 4e^(-10t)" A") "for" t >=0
$
$
  i_(o)(t) = 4/(16 + 4)i_(L)(t) = 0.8e^(-10t) \
  -v_(o)(t) = 10i_(o)(t) \
  boxed(v_(o)(t) = -8e^(-10t)" V") "for" t>=0
$

=== Step 2. Simulate the circuit and confirm the result in Step 1
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_01/part_01.py",
)[View simulation code]

#figure(
  image("../simulations/figures/lab_01/part_01.png", width: 80%),
  caption: [The simulation agrees with the theoretical first-order RL response. At $t = 0^(+)$, the inductor current remains continuous at $qty("4", "A")$, while $v_(o)$ changes instantaneously to $qty("-8", "V")$ because resistor voltage is not required to be continuous. The response then decays exponentially toward $qty("0", "V")$ with a time constant of $qty("0.1", "s")$. After approximately five time constants, or $qty("0.5", "s")$, the response is essentially at steady state.],
)

=== Step 3. Find the time at which $75%$ of the initial stored energy has been dissipated.

$
  w(t) = 1/2 L i^2 (t)\
  w(t) = 2.56 e^(-20t)" J" \
  \
  (1 - 0.75)w(0) = 2.56 e^(-20t) \
  => t = -1/20 ln((0.25w(0))/2.56) \
  boxed(t = qty(#round3(-1 / 20 * calc.ln(0.64 / 2.56)), "s"))
$

= No. 2

=== Step 1. Find $i(t)$ for $t >= 0^(+)$

#let before = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults, foreground: white)

  // node("a", (-2.5, 3))
  // node("b", (2.5, 3))
  vsource(
    "v",
    (-2.5, 0),
    (-2.5, 3),
    label: (
      content: $qty("24", "V")$,
      anchor: "south",
    ),
  )
  resistor("r1", (-2.5, 3), (2.5, 3), label: (
    content: $qty("2", "ohm")$,
  ))
  swire((-2.5, 0), (2.5, 3))

  current-annotation(
    (2.5, 3),
    (2.5, 0),
    side: "right",
    arrow_offset: 8pt,
  )
})

#let after = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  inductor("l", (-3, 3), (-3, 0), label: (
    content: $qty(200, "mH")$,
  ))
  current-annotation("l.in", "l.out")

  node("a", (-0.5, 3))
  node("b", (-0.5, 0))
  wire("l.in", "a")
  wire("l.out", "b")
  resistor("r2", "a", "b", label: (
    content: $qty(10, "ohm")$,
  ))

  isource("i", (2.5, 3), (2.5, 0), label: (
    content: $qty("8", "A")$,
    anchor: "south",
  ))
  wire("a", "i.in")
  wire("b", "i.out")

  cetz.draw.set-style(zap: circuit-defaults)
})

#align(center)[
  #grid(
    columns: (auto, 0pt, auto),
    rows: (auto, auto),
    column-gutter: 3.5em,
    row-gutter: 0.7em,

    grid.cell(
      x: 0,
      y: 0,
      align: center + bottom,
    )[#before],

    grid.cell(
      x: 1,
      y: 0,
      align: center + horizon,
    )[
      #move(dy: 1em, dx: 0.5em)[
        #text(size: 24pt)[$arrow.r.long$]
      ]
    ],

    grid.cell(
      x: 2,
      y: 0,
      align: center + bottom,
    )[#after],

    grid.cell(
      x: 0,
      y: 1,
      align: center + horizon,
    )[
      #move(dx: 1em)[$t = 0^(-)$]
    ],

    grid.cell(
      x: 2,
      y: 1,
      align: center + horizon,
    )[
      $t = 0^(+)$
    ],
  )
]

for $t = 0^(-)$ :

$
  i(0^(-) ) = 24/2 =qty("12", "A")
$

for $t > 0$ :
$
  i(0^(+) )=i(0^(-) ) = qty("12", "A") \
  R_("eq") = qty("10", "ohm") \
  tau = L/R_("eq") = 0.2/10 = qty("0.02", "s")
$

As $t -> oo$, the inductor shorts and all $qty("8", "A")$ from the current source flows through it. Since $i$ is defined in the opposite direction as the source, we flip the sign.
$
  i(oo) = qty("-8", "A") \
  i(t) = i(oo) + [i(0^(+)) - i(oo) ] e^(-t\/tau) \
  i(t) = -8 + [12-(-8) ] e^(-t\/0.02) \
  boxed(i(t) = -8 + 20 e^(-50t)" A") "for" t>= 0 \
$

#pagebreak()
=== Step 2. Simulate the circuit and confirm the result in Step 1
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_01/part_02.py",
)[View simulation code]


#figure(
  image("../simulations/figures/lab_01/part_02.png", width: 80%),
  caption: [The simulated response begins at $i(0^(+)) = qty("12", "A")$, confirming continuity of inductor current. It then decreases exponentially toward the steady-state value of $qty("-8", "A")$ with $tau = qty("20", "ms")$. The current crosses zero at approximately $qty("18.3", "ms")$; the negative final value indicates that the steady-state current flows opposite to the reference direction chosen for $i$. By about $5tau = qty("100", "ms")$, the circuit is essentially at steady state.],
)

= No. 3

=== Step 1. Find $v(t)$ for $t >= 0^(+)$


#let before = zap.circuit({
  import zap: *

  cetz.draw.set-style(zap: circuit-defaults)

  node("a", (0, 1.5))
  node("b", (0, -1.5))
  node("c_in", (-3, -1.5), fill: false)
  node("c_out", (-3, 1.5), fill: false)

  // capacitor("c", (-3, -1.5), (-3, 1.5), polarized: true, label: (
  //   content: $qty("0.5", "uF")$,
  //   anchor: "south",
  // ))
  voltage-annotation("c_out", "c_in", label: $v$, length: 5em)
  resistor("r1", "a", "b", label: (
    content: $qty("60", "ohm")$,
    anchor: "south",
  ))
  vsource("v1", (3, 1.5), (3, -1.5), label: (
    content: $qty("40", "V")$,
    anchor: "south",
  ))
  resistor("r2", "a", "v1.in", label: (
    content: $qty("20", "ohm")$,
    anchor: "north",
  ))
  wire("c_out", "a")
  wire("c_in", "b")
  wire("b", "v1.out")
})

#let after = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  vsource("v2", (-1.5, -1.5), (-1.5, 1.5), label: (
    content: $qty("90", "V")$,
    anchor: "south",
  ))
  capacitor("c", (3, -1.5), (3, 1.5), polarized: true, label: (
    content: $qty("0.5", "uF")$,
    anchor: "south",
  ))
  voltage-annotation("c.out", "c.in", offset: 2em, length: 5em)
  resistor("r3", "v2.out", "c.out", label: (
    content: $400" k"Omega$,
  ))
  wire("v2.in", "c.in")
})

#align(center)[
  #grid(
    columns: (auto, 0pt, auto),
    rows: (auto, auto),
    column-gutter: 3.5em,
    row-gutter: 0.7em,

    grid.cell(
      x: 0,
      y: 0,
      align: center + bottom,
    )[#before],

    grid.cell(
      x: 1,
      y: 0,
      align: center + horizon,
    )[
      #move(dy: 1em)[
        #text(size: 24pt)[$arrow.r.long$]
      ]
    ],

    grid.cell(
      x: 2,
      y: 0,
      align: center + bottom,
    )[#after],

    grid.cell(
      x: 0,
      y: 1,
      align: center + horizon,
    )[
      $t = 0^(-)$
    ],

    grid.cell(
      x: 2,
      y: 1,
      align: center + horizon,
    )[
      #move(dx: -1em)[
        $t = 0^(+)$]
    ],
  )
]

for $t = 0^(-)$ :

$
  i = 40/(60 + 20) = qty("0.5", "A") \
  -v(0^(-) ) = 60i \
  => v(0^(-) ) = qty("-30", "V")
$

for $t > 0^(+)$ :

$
  v(0^(+) ) = v(0^(-) ) = qty("-30", "V") \
  R_("eq") = 400" k"Omega \
  tau = R_("eq") C = (400" "upright(k) Omega)(qty("0.5", "uF")) = qty("0.2", "s")
$

$
  v(oo) = qty("90", "V") \
  v(t) = v(oo) + [v(0^(+)) - v(oo) ] e^(-t\/tau) \
  v(t) = 90 + [-30 - 90] e^(-t\/0.2) \
  boxed(v(t) = 90 - 120e^(-5t)" V")" for" t >= 0
$

=== Step 2. Implement the circuit on a breadboard and confirm the result in Step 1

#grid(
  columns: (62.7%, auto),
  gutter: 6pt,
  image("images/lab_01/part_03_01.jpg"),
  grid(
    gutter: 6pt,
    image("images/lab_01/part_03_02.jpg"),
    image("images/lab_01/part_03_03.jpg"),
    image("images/lab_01/part_03_04.jpg"),
  ),
)

For the physical implementation, the source voltages were scaled down by a factor of 10 from the theoretical circuit. Therefore, the $qty("40", "V")$ and $qty("90", "V")$ sources were implemented as approximately $qty("4", "V")$ and $qty("9", "V")$, respectively. Since the resistor and capacitor values were unchanged, the time constant remained
$
  tau = R_("eq") C = (400" "upright(k) Omega)(qty("0.5", "uF")) =qty("0.2", "s").
$
Scaling down the source voltages by a factor of 10 also scales the capacitor voltage by the same factor. Thus, the experimental response was expected to be
$
  v_("exp")(t) = 9 - 12e^(-5t)" V"
$
with an initial voltage of approximately $qty("-3", "V")$ and a final steady-state voltage of approximately $qty("9", "V")$. The measured power-supply values of approximately $qty("-3.23", "V")$ (or $qty("-3.96", "V")$) and $qty("9.18", "V")$ are consistent with the scaled voltage sources used in the experiment. The experimental circuit therefore preserves the same first-order RC behavior and time constant as the original theoretical circuit, while operating at lower voltage levels.

=== Step 3. Simulate the circuit and confirm the result in Steps 1-2.
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_01/part_03.py",
)[View simulation code]

#figure(
  image(
    "../simulations/figures/lab_01/part_03.png",
    width: 80%,
  ),
  caption: [The capacitor voltage is continuous through switching, so $v(0^(+)) = v(0^(-)) = qty("-30", "V")$. After switching, the capacitor charges toward the $qty("90", "V")$ steady-state value through the $400" "upright(k) Omega$ resistance. The resulting time constant is $tau = qty("0.2", "s")$. The theoretical response therefore rises exponentially from $qty("-30", "V")$ toward $qty("90", "V")$ and is essentially settled after approximately $5tau = qty("1", "s")$. The simulated waveform reflects this expected behavior.],
)
