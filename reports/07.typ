#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *
#import "@preview/zero:0.7.1": num


#show: report.with(
  title: [Lab 7: Power Analysis: Part 1],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "October 12, 2026",
  report-date: "October 26, 2026",
)

= No 1.

=== Step 1. Determine the expression for the instantaneous power given that both voltage and current are sinusoidal functions given below
$
  v(t) = V_(m)cos(omega t + theta_(v)), quad i(t) = I_(m) cos(omega t + theta_(i))
$

$
  p(t) = v(t)i(t) \
  p(t)= V_(m)I_(m)cos(omega t + theta_(v))cos(omega t + theta_(i))
$

recall that
$
  cos(A)cos(B) = 1/2 [cos(A-B) +cos(A + B)]
$

thus

$
  boxed(
    p(t) = (V_(m)I_(m))/2 [ cos(theta_(v) - theta_(i)) + cos(2omega t + theta_(v) + theta_(i)) ],
    inset: #0.8em
  )
$

=== Step 2. Sketch: $v(t)$, $i(t)$, and power $p(t)$ all on the same graph
#code-link(7, 1)
#figure(
  image("../simulations/figures/lab_07/part_01.png", width: 65%),
  caption: [Sinusoidal voltage $v(t)$, current $i(t)$, and instantaneous power $p(t)$ plotted over one complete cycle, using assumed values $V_(m) = qty("1", "V")$, $I_(m) = qty("1", "A")$, $omega=1 "rad/s"$, $theta_(v) = 0degree$, and $theta_(i) = -60degree$. The current lags the voltage by $60degree$, while the instantaneous power oscillates at twice the frequency of the voltage and current.],
)

= No 2.

=== Step 1. Suppose the power factor of an impedance is $0.7$ leading. What is the simplest model of this impedance?

A leading power factor means current leads voltage, so the impedance angle is negative:

$
  phi = -cos^(-1)(0.7) = -45.57degree
$

The impedance consists of some (positive) resistance and some (negative) reactance, so a resistor and capacitor in series can represent it.

=== Step 2. Simulate the circuit you designed in Step 1 to confirm your design.

assuming $R = qty("100", "ohm")$:
$
  Z = R + 1/(j omega C) = R + j X_(C) \
  tan(phi) = Im(Z)/Re(Z) = X_(C)/R \
  => |X_(C)| = R tan|phi| approx qty("102.02", "ohm")
$
assuming a frequency of $60 "Hz"$,
$
  |X_(C)| = 1/(omega C) = 1/(2pi f C) \
  C approx qty("26", "uF")
$

#code-link(7, 2)
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
    C = 26.001 uF
    Z = 100.000 - j102.020 ohm
    Power factor = 0.7000
    Current leads voltage by 45.57 degrees
    ```
  ]
]

= No 3.

=== Step 1. Find the average power, the reactive power, and the power factor for the circuit shown.


$
  i(t) = 20 cos(omega t + 15degree)" A", quad v(t) = 100 cos(omega t - 45degree)" V"
$

$
  vbold(I) = 20 angle 15degree , quad vbold(V) = 100 angle -45degree
$
$
  vbold(S) = 1/2 vbold(V) vbold(I)^(*) = 1/2 (100angle - 45degree )(20angle -15degree ) = 1000angle - 60degree
$
$
  => vbold(S) = 500 - j 866.025 "VA"\
  => boxed(P = qty("500", "W")\, quad Q = -866.025 "VAR")
$

$
  phi = arg(vbold(I)) - arg(vbold(V)) = 60degree "(leading)"\
  |cos (phi)| = 0.5 \
  => boxed("pf" = 0.5 "leading")
$

=== Step 2. Is the power factor leading or lagging?

$
  arg(vbold(I)) - arg(vbold(V)) > 0 => "leading"
$

=== Step 3. Estimate the real and imaginary parts of the power

$
  Re(vbold(S)) & = P = qty("500", "W") \
  Im(vbold(S)) & = Q = -866.025 "VAR"
$
= No 4.

=== Step 1. Find the average power, the reactive power, and the power factor for the circuit shown.

$
  i(t) = 20 cos(omega t + 165degree)" A", quad v(t) = 100 cos(omega t - 45degree)" V"
$

$
  vbold(I) = 20angle 165degree , quad vbold(V) = 100angle -45degree \
  vbold(S) = 1/2 vbold(V)vbold(I^(*)) = 1000 angle -210degree equiv 1000 angle 150degree\
  => vbold(S) = -866.025 + j 500 "VA" \
  => boxed(P = qty("-866.025", "W")\, quad Q = 500 "VAR")
$

$
  phi = arg(vbold(I)) - arg(vbold(V)) = 210degree equiv 150degree "(lagging)" \
  |cos(phi)| = 0.866 \
  => boxed("pf" = 0.866 "lagging")
$

=== Step 2. Estimate what the simplest model of the circuit inside the box is, and why?

$
  P < 0 & => "delivering real power" \
  Q > 0 & => "absorbing reactive power" \
$

$
  Z = vbold(V)/vbold(I) = 5 angle -210degree = 5angle 150degree \
  Z = -4.33 + j 2.5 Omega
$

Thus, the simplest model that can represent the circuit is an inductor and an active element/source in series. It should have an equivalent resistance of $qty("-4.33", "ohm")$ and an equivalent reactance of $qty("2.5", "ohm")$.
