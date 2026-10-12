#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *
#import "@preview/zero:0.7.1": num


#show: report.with(
  title: [Lab 6: Phasors - Part 2],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "October 5, 2026",
  report-date: "October 12, 2026",
)

= No 1.

=== Step 1. Find the value of the phasor current $vbold(I)$ in the phasor-transformed circuit shown.

#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      vsource("", (-1, -2.5), (-1, 2.5), label: (
        content: $33.8 angle 0 degree \ "    V"$,
        anchor: "south",
      ))
      resistor("r", (-1, 2.5), (1.5, 2.5), label: $qty("1", "ohm")$)
      inductor("l", (1.5, 2.5), (4, 2.5), label: $j qty("2", "ohm")$)
      current-annotation(
        (1, 2.5),
        (2, 2.5),
        arrow_offset: 1em,
        length: 1,
        label: $vbold(I)$,
      )
      node("a", (4, 2.5))
      node("b", (4, -2.5))
      resistor("", "a", (4, 0), label: (
        content: $qty("3", "ohm")$,
      ))
      capacitor("c", (4, -2.5), (4, 0), polarized: true, label: (
        content: $-j qty("5", "ohm")$,
        anchor: "south",
      ))
      voltage-annotation(
        "c.out",
        "c.in",
        offset: 2em,
        label: $vbold(V)_(x)$,
      )
      resistor("", (7, -2.5), (7, 2.5), label: $qty("2", "ohm")$)
      disource("", (10, -2.5), (10, 2.5), label: $0.75" "vbold(V)_(x)$)
      node("", (7, 2.5))
      node("", (7, -2.5))
      node("", (10, 2.5))
      node("", (10, -2.5))
      wire("a", (10, 2.5))
      wire((-1, -2.5), (10, -2.5))
      wire((10, 2.5), (12, 2.5))
      wire((10, -2.5), (12, -2.5))
      node("", (12, 2.5), fill: false)
      node("", (12, -2.5), fill: false)
      voltage-annotation(
        (12, 2.5),
        (12, -2.5),
        length: 4,
        label: $vbold(V)$,
      )
    })
  ]
]

$
  vbold(V)_(x) = vbold(V)((-j 5)/(3 -j 5)) = -vbold(V)((j 5)/(3 - j 5))
$
$
  underbrace((vbold(V) - vbold(V)_(s) )/(1 + j 2), -vbold(I)) + vbold(V)/(3 - j 5) + vbold(V)/2 - 0.75 vbold(V)_(x) &= 0 \
  (vbold(V) - 33.8 )/(1 + j 2) + vbold(V)/(3 - j 5) + vbold(V)/2 &= -0.75vbold(V)((j 5)/(3 - j 5)) \
  vbold(V)/(1 + j 2) + vbold(V)/(3 - j 5) + vbold(V)/2 + 0.75 vbold(V)((j 5)/(3 - j 5)) &= 33.8/(1 + j 2) \
  vbold(V)[1/(1 + j 2) + 1/(3 - j 5) + 1/2 +0.75((j 5)/(3 - j 5))] &= 33.8/(1 + j 2) \
$
$
  vbold(V) = 60.642 angle -81.66 degree thin "V" \
  vbold(I) = - (vbold(V) - vbold(V)_(s) )/(1 + j 2) \
  => boxed(vbold(I) = 29.069 angle 3.95 degree thin "A")
$

=== Step 2. Simulate the circuit to confirm your results in Step 1.
#figure(
  image("../simulations/figures/lab_06/part_01.png"),
  caption: [Time-domain current waveform illustrated at an assumed frequency of 1 kHz and corresponding phasor and corresponding phasor, $vbold(I) = 29.069 angle 35degree thin "A"$.],
)

= No 2.
=== Step 1. Determine the time-domain expression for the steady-state value of $v_(o)(t)$ (voltage drop across the inductor) for the circuit shown below.

#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      vsource("", (-1, -2), (-1, 2), label: $v_1$)
      resistor("", (-1, 2), (3, 2), label: $qty("20", "ohm")$)
      node("", (3, 2))
      node("", (3, -2))
      inductor("", (3, 2), (3, -2), label: $qty("125", "uH")$)
      vsource("", (7, 2), (7, -2), label: $v_2$)
      capacitor("", (7, 2), (3, 2), polarized: true, label: (
        content: $qty("1.25", "uF")$,
        anchor: "south",
      ))
      wire((-1, -2), (7, -2))
      current-annotation((3, 2), (3, -2), arrow_offset: 0.5em, label: $i_(o)$)
    })
  ]
]
$
  v_1 (t) = 5cos(num(80000)t)" V" \
  v_2 (t) = -2.5cos(num(320000)t)" V"
$

set $v_2 =0$, replacing the ideal voltage source with a short circuit:
$
  omega = num(80000)" rad/s" \
  vbold(V)_(1) = 5angle 0degree thin "V" , quad Z_(L) = j qty("10", "ohm"), quad Z_(C) = -j qty("10", "ohm")
$

notice:
$
  Y_(L) + Y_(C) = -j 1/10 + j 1/10 = 0
$
this means the net current entering the inductor and capacitor is 0, meaning there is no voltage drop across the resistor:
$
  vbold(V)_(o_1) = vbold(V) = 5angle 0degree thin "V"
$

now leave only $v_2$ on:
$
  omega = num(320000)" rad/s" \
  vbold(V)_(2) =-2.5 angle 0degree thin "V", quad Z_(L) = j qty("40", "ohm"), quad Z_(C) = -j qty("2.5", "ohm")
$
flip source and use voltage division
$
  Z_(parallel ) = 20 parallel Z_(L) = 16 + j qty("8", "ohm")\
$
$
  vbold(V)_(o_2) & = (-vbold(V)_(2) ) (Z_(parallel ) )/(Z_(parallel )+Z_(C)) \
                 & = 2.5 (16 + j 8)/(16 + j 5.5) \
                 & = 2.643 angle 7.59degree thin "V"
$

so,
$
  v_o_1 (t) & = 5cos(num(80000)t) thin "V" \
  v_o_2 (t) & = 2.643cos(num(320000)t + 7.59degree) thin "V"
$

thus,
$
  boxed(v_(o)(t) = 5cos(num(80000)t) + 2.643cos(num(320000)t + 7.59 degree) thin "V")
$


=== Step 2. Simulate the circuit to confirm your results in Step 1.
#code-link(5, 2)
#figure(
  image("../simulations/figures/lab_06/part_02.png"),
  caption: [Comparison of the simulated inductor voltage and analytical steady-state response. The initial transient decays, and the simulated waveform approaches the analytical result.],
)

= No 3.
=== Step 1. Given the circuit below, compute the impedance $Z$

#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      node("a", (-1, 3), fill: false)
      node("b", (-1, -3), fill: false)
      node("", (1, 3))
      node("", (1, -3))
      wire("a", (1, 3))
      wire("b", (1, -3))
      resistor("", (1, -3), (1, 3), label: (
        content: $qty("3", "ohm")$,
        anchor: "south",
      ))
      resistor("", (1, 3), (5, 3), label: $qty("2", "ohm")$)
      resistor("", (5, 0), (5, 3), label: (
        content: $qty("4", "ohm")$,
      ))
      capacitor("", (5, -3), (5, 0), polarized: true, label: (
        content: $-j qty("3", "ohm")$,
        anchor: "south",
      ))
      inductor("", (1, -3), (5, -3), label: (
        content: $-j qty("3", "ohm")$,
        anchor: "south",
      ))
      resistor("", (9, -3), (9, 0), label: (
        content: $qty("4", "ohm")$,
        anchor: "south",
      ))
      inductor("", (5, 0), (9, 0), label: $j qty("2", "ohm")$)
      inductor("", (5, 3), (9, 3), label: $j qty("3", "ohm")$)
      resistor("", (1, -3), (5, 0), label: $qty("5", "ohm")$)
      wire((5, 0), (9, 3))
      node("", (5, 3))
      node("", (5, 0))
      node("", (5, -3))
      wire((5, -3), (9, -3))

      cetz.draw.line(
        (-1, 0),
        (0.5, 0),
        stroke: annotation-blue + 0.8pt,
        mark: (
          end: ">",
          fill: annotation-blue,
          stroke: annotation-blue,
          length: 0.25,
          width: 0.14,
        ),
      )
      cetz.draw.content(
        (-1.25, 0),
        text(fill: annotation-blue)[
          $Z$
        ],
        anchor: "center",
      )
    })
  ]
]
($-j qty("3", "ohm")$ inductor likely a typo?)

$
  (underbrace((4 parallel j 3), Z_(A)) + ((underbrace((- j 3 parallel (4 + j 2)) - j 3, Z_(B))) parallel 5) + 2 ) parallel 3 \
$

$
  Z_(A) & = 36/25 + j 48/25 thin Omega \
  Z_(B) & = 36/17 - j 93/17 thin Omega
$
then,
$
  Z_(C) = (Z_(B) parallel 5) + 2 = 1313/274 - j 465/274 thin Omega
$
so,
$
  Z = (Z_(A) + Z_(C) )parallel 3 \
  boxed(Z = 2.0258 angle 0.6654degree thin Omega)
$

=== Step 2. Simulate the circuit to confirm your results in Step 1.
#code-link(6, 3)
#figure(
  image("../simulations/figures/lab_06/part_03.png", width: 80%),
  caption: [Comparison of the calculated and simulated real and imaginary components of the input impedance, showing agreement with $Z = 2.0258 + j 0.6654degree thin Omega .$],
)
