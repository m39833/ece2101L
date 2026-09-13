#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *

#show: report.with(
  title: [Lab 2: Multi-Switching First-Order Circuits],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "August 31, 2026",
  report-date: "September 2, 2026",
)

= No. 1

=== Step 1. Both switches have been closed for a long time. At $t=0$, switch 1 is opened and stays open. Switch 2 opens $qty(35, "ms")$ later and stays open. Find the expression for the voltage drop across the inductor for $t>=0^(+)$. <s-1>

#align(center)[
  #zap.circuit({
    import zap: *
    cetz.draw.set-style(zap: circuit-defaults)

    node("a", (-3, 1.5))
    vsource("v", (-6, -1.5), (-6, 1.5), label: (
      content: $qty("60", "V")$,
      anchor: "south",
    ))
    resistor("r1", (-6, 1.5), "a", label: (
      content: $qty("4", "ohm")$,
    ))
    resistor("r2", "a", (-3, -1.5), label: (
      content: $qty("12", "ohm")$,
    ))
    node("b", (0, 1.5))
    wire("a", "b")
    resistor("r3", "b", (0, -1.5), label: (
      content: $qty("6", "ohm")$,
    ))
    let c = (3, 1.5)
    resistor("r4", "b", c, label: (
      content: $qty("3", "ohm")$,
    ))
    // inductor("l", "c", (3, -1.5), label: (
    //   content: $qty("150", "mH")$,
    // ))
    wire(c, (3, -1.5))
    voltage-annotation(c, (3, -1.5), label: $v_L$, length: 6em, offset: 1em)
    current-annotation(
      c,
      (3, -1.5),
      side: "left",
      length: 5em,
      label: $i_L$,
      arrow_offset: 1em,
    )
    // wire("c", (6, 1.5))
    // resistor("r5", (6, 1.5), (6, -1.5), label: (
    //   content: $qty("18", "ohm")$,
    // ))
    wire((-6, -1.5), (3, -1.5))
    node("", (-3, -1.5))
    node("", (-0, -1.5))
    // node("", (3, -1.5))
  })
  $
    t = 0^(-)
  $
]

#let flip1 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  resistor("r3", (0, 1.5), (0, -1.5), label: (
    content: $qty("6", "ohm")$,
  ))
  node("c", (3, 1.5))
  resistor("r4", (0, 1.5), "c", label: (
    content: $qty("3", "ohm")$,
  ))
  inductor("l", "c", (3, -1.5), label: (
    content: $qty("150", "mH")$,
  ))
  voltage-annotation("l.in", "l.out", label: $v_L$, length: 6em)
  current-annotation(
    (3.5, 2),
    (3.5, -0.5),
    side: "left",
    length: 2.5em,
    label: $i_L$,
  )
  wire("c", (6, 1.5))
  resistor("r5", (6, 1.5), (6, -1.5), label: (
    content: $qty("18", "ohm")$,
  ))
  wire((0, -1.5), (6, -1.5))
  node("", (3, -1.5))
})
#let flip2 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  resistor("r3", (0, 1.5), (0, -1.5), label: (
    content: $qty("6", "ohm")$,
  ))
  resistor("r4", (0, 1.5), (3, 1.5), label: (
    content: $qty("3", "ohm")$,
  ))
  inductor("l", (3, 1.5), (3, -1.5), label: (
    content: $qty("150", "mH")$,
  ))
  voltage-annotation("l.in", "l.out", label: $v_L$, length: 6em)
  current-annotation(
    (3.5, 2),
    (3.5, -0.5),
    side: "left",
    length: 2.5em,
    label: $i_L$,
  )
  wire((0, -1.5), (3, -1.5))
})

#align(center)[
  #scale(95%, reflow: false)[
    #grid(
      columns: (auto, auto),
      column-gutter: 6em,
      align: center + horizon,

      align(center)[
        #flip1
        #move(dx: -1em)[$t in (0, 35)" ms"$]
      ],

      align(center)[
        #flip2
        #move(dx: -1.5em)[$t = 35" ms"^(+)$]
      ],
    )
  ]
]

for $t = 0^(-)$ :

$
  i_s = 60/(4 + (12 parallel 6 parallel 3)) = qty("10.5", "A") \
  v_a = v_s - 4i_s = qty("18", "V")
$

$
  (v_a - 60)/4 + v_a/12 + v_a/6 + i_L = 0 \
  3v_a + v_a + 2v_a + 12i_L = 180 \
  => i_(L)(0^(-) ) = qty("6", "A")
$

for $t in [0, 35)$ :

$
  i_(L)(0^(+) ) = i_(L)(0^(-) ) = qty("6", "A") \
  R_("eq") = (6 + 3) parallel 18 = qty("6", "ohm") \
  tau = L/R_("eq") = qty("150", "mH")/qty("6", "ohm") = 1/40" s"
$

$
  i_(L)(t) = cancelto(0, i_(L)(oo)) + [i_(L)(0^(+) ) - cancelto(0, i_(L)(oo)) ]e^(-t\/tau) \
  i_(L)(t) = 6e^(-40t)" for" t in [0, 35)" ms"
$

$
  v_(L)(t) = L (dif i_(L) ) / (dif t) \
  => boxed(v_(L)(t) = -36e^(-40t)" V")" for" t in [0, 35)" ms"
$

for $t >= qty("35", "ms")$ :

$
  i_(L)(35" ms"^(+) ) = i_(L)(35" ms"^(-) ) = 6e^(-1.4)" A" \
  R_("eq") = 3 + 6 = qty("9", "ohm")\
  tau = L/R_("eq") = qty("150", "mH")/qty("9", "ohm") = 1/60" s" \
  i_(L)(t) = cancelto(0, i_(L)(oo)) + [i_(L)(35" ms"^(+) ) - cancelto(0, i_(L)(oo)) ]e^(-t\/tau) \
  i_(L)(t) = 6e^(-1.4)e^(-60t) \
  i_(L)(t) = 6e^(-60t - 1.4)" A"" for" t>= 35" ms"
$

$
  v_(L)(t) = L (dif i_(L) ) / (dif t) \
  => v_(L)(t) = -54e^(-60t - 1.4)" V"
$

offset $v_(L)(t)$ for $t >= qty("35", "ms")$ :

$
  v_(L)(t) = -54e^(-60(t - 0.035) - 1.4) \
  => boxed(v_(L)(t) = -54e^(-60t + 0.7)" V")" for" t>= qty("35", "ms")
$

thus, for $t >= 0$ :

#align(center)[
  #boxed(
    $
      v_(L)(t) = cases(
        -36e^(-40t) & " V" & "for" t in [0, 35)" ms",
        -54e^(-60t + 0.7) & " V" & "for" t >= qty("35", "ms")
      )
    $,
    inset: 1em,
  )
]

=== Step 2. Simulate the circuit and confirm the results in Step 1.

#figure(
  image("../simulations/figures/lab_02/part_01.png"),
  caption: [The simulated response agrees with the theoretical piecewise solution. From $t in [0, 35)" ms"$, the inductor voltage follows $v_(L)(t) = -36e^(-40t)" V"$ with a time constant of $qty("25", "ms")$. At $t = qty("35", "ms")$, the second switch opens, changing the equivalent resistance from $qty("6", "ohm")$ to $qty("9", "ohm")$ and reducing the time constant to approximately $qty("16.7", "ms")$. Because inductor current is continuous, $i_(L)(qty("35", "ms")^(+) ) = i_(L)(qty("35", "ms")^(-) ) approx qty("1.48", "A")$; however, the inductor voltage changes from approximately $qty("-8.88", "V")$ to $qty("-13.32", "V")$ due to the change in equivalent resistance. For $t>=qty("35", "ms")$, the voltage follows $v_(L)(t) = -54e^(-60t+0.7)" V"$ and decays to zero.],
)
