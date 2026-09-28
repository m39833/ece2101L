#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *

#show: report.with(
  title: [Lab 4: RLC Circuits - Part 2],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "September 16, 2026",
  report-date: "September 21, 2026",
)

= No 1.

=== Step 1. Given the circuit shown, calculate the expression for $v(t)$ for $t >= 0$

#align(center)[
  #scale(95%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      inductor("l", (-3, -4), (-3, 4), label: (
        content: $qty("2", "H")$,
        anchor: "south",
      ))
      current-annotation(
        (-3, -4),
        (-3, 4),
        arrow_offset: 1.5em,
        side: "left",
        label: $1/2" A"$,
        color: color.black,
      )
      wire((-3, 4), (3, 4))
      current-annotation(
        (-3, 4),
        (3, 4),
        arrow_offset: 1em,
        label: $i(t)$,
      )
      resistor("r1", (3, 4), (3, 0), label: (
        content: $R_(1) = qty("10", "ohm")$,
      ))
      capacitor("c", (1, -4), (1, 0), polarized: true, label: (
        content: $1/8" F"$,
        anchor: "south",
      ))
      voltage-annotation(
        (1, 0),
        (1, -4),
        offset: 2.5em,
        label: $qty("1", "V")$,
        color: color.black,
      )
      resistor("c", (5, -4), (5, 0), label: (
        content: $R_(2) = qty("8", "ohm")$,
        anchor: "south",
      ))
      voltage-annotation((3, 0), (3, -4), label: $v(t)$, length: 7em)
      wire((1, 0), (5, 0))
      wire((-3, -4), (5, -4))
      node("", (3, 0))
      node("", (1, -4))
    })
  ]
]

notice
$
  v(t) = v_(C)(t) \
  v(0^(+) ) = qty("1", "V") \
  i_(L)(0^(+) ) = 1/2 "A"
$
and using KCL:
$
   i(t) & = i_(C) + i_(R_(2) ) \
        & = C (dif v) / (dif t) + 1/R_(2)v \
   i(t) & = 1/8v' + 1/8 v \
  i'(t) & = 1/8v'' + 1/8 v'
$

now use KVL:

$
  0 & = v_(L) + R_(1)i + v \
  0 & = L (dif i) / (dif t) + R_(1)i + v \
  0 & =2 (1/8 v'' + 1/8v') + 10(1/8v' + 1/8 v) + v \
  0 & = 1/4v'' + 1/4v' + 5/4v' + 5/4v + v \
  0 & = v'' + 6v' + 9v
$
writing the characteristic equation and solving:

$
  s^2 +6s + 9 & = 0 \
      (s+3)^2 & = 0
$

this is a critically damped circuit with a double root of $-3$:
$
  v(t) = (A + B t)e^(-3t)
$

now recall $v(0) = qty("1", "V")$. substituting into the solution for $v(t)$ yields
$
  A = 1
$

to find $B$, use the KCL equation at $t = 0$:
$
   i(0) & = C (dif v(0)) / (dif t) + 1/R_(2) v(0) \
    1/2 & = 1/8 v'(0) + 1/8 \
  v'(0) & = 3 "V/s"
$

now differentiating the solution,
$
  v'(0) & = B - 3 A \
      B & = 6
$

thus,
$
  boxed(v(t) = (1 + 6t)e^(-3t)" V")" for" t >= 0
$




=== Step 2. Simulate the circuit to confirm your result in Step 1.
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_04/part_01.py",
)[View simulation code]
#figure(
  image("../simulations/figures/lab_04/part_01.png"),
  caption: [Simulated voltage $v(t)$, confirming the critically damped response obtained analytically. The voltage begins at $qty("1", "V")$, rises slightly due to the initial inductor current, and then decays smoothly to $qty("0", "V")$ without oscillation.],
)


= No 2.

=== Step 1. Given the circuit shown, calculate the expression for $v_(C) (t)$ for $t >= 0$

#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      vsource("v", (-3, -1.5), (-3, 1.5), label: (
        content: $12u(t)" V"$,
      ))
      resistor("r", (-3, 1.5), (0, 1.5), label: (
        content: $qty("6", "ohm")$,
      ))
      inductor("l", (0, 1.5), (3, 1.5), label: (
        content: $qty("1", "H")$,
      ))
      current-annotation(
        "l.in",
        "l.out",
        label: $qty("4", "A")$,
        color: color.black,
      )
      capacitor(
        "c",
        (3, -1.5),
        (3, 1.5),
        polarized: true,
        label: (
          content: $qty("0.04", "F")$,
        ),
      )
      voltage-annotation(
        "c.out",
        "c.in",
        side: "left",
        offset: 2.5em,
        label: $qty("-4", "V")$,
        color: color.black,
      )
      wire((-3, -1.5), (3, -1.5))
    })
  ]
]

for a series RLC configuration:
$
  alpha = R/2L, " " omega_(0) = 1/sqrt(L C) \
  alpha = qty("3", "1/s"), " " omega_(0) = 5 "rad/s" \
$

since $alpha < omega_(0)$, the system is underdamped, with
$
  omega_(d) = sqrt(omega_(0)^2 -alpha^2) = 4
$

this is a step response with $v_(C) (oo) = qty("12", "V")$, so
$
  v_(C)(t) = 12 + e^(-3t) [A cos(4t) + B sin(4t)]
$
notice
$
  v_(C)(0^(+) ) = v_(C)(0^(-) ) = qty("-4", "V")
$
so at $t=0$,
$
  -4 & = 12 + A \
   A & = -16
$
now to obtain $B$, notice
$
  i(0^(+) ) = qty("4", "A") \
$
then
$
                              i & = C (dif v_(C) ) / (dif t) \
  (dif v_(C)(0^(+) )) / (dif t) & = i(0^(+) )/C \
  (dif v_(C)(0^(+) )) / (dif t) & = 100 "V/s"
$
now differentiate the solution and evaluate it at $t=0$:
$
  v'(0) & = -alpha A + omega_(d) B \
      B & = (v'(0) + alpha A)/omega_(d) \
      B & = 13
$

thus,
$
  boxed(v_(C) (t) = 12 + e^(-3t) [-16cos(4t) + 13sin(4t)]" V")" for "t>=0
$


=== Step 2. Simulate the circuit to confirm your result in Step 1.
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_04/part_02.py",
)[View simulation code]
#figure(
  image("../simulations/figures/lab_04/part_02.png"),
  caption: [Simulated capacitor voltage $v_(C)(t)$, showing the expected underdamped step response. The capacitor voltage begins at $qty("-4", "V")$, overshoots the $qty("12", "V")$ steady-state value, and then settles to $qty("12", "V")$ through decaying oscillations.],
)

= No 3.

=== Step 1. Given the circuit shown, calculate the expression for $v(t)$ for $t >= 0$


#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      vsource("vs", (-3, -2), (-3, 2), label: (
        content: $v_(s)$,
      ))
      inductor("l", (-3, 2), (1, 2), label: (
        content: $qty("2", "H")$,
      ))
      resistor("r1", (1, 2), (5, 2), label: (
        content: $qty("10", "ohm")$,
      ))
      current-annotation(
        "r1.in",
        "r1.out",
        arrow_offset: 1.5em,
        label: $i(t)$,
      )
      capacitor("c", (5, -2), (5, 2), polarized: true, label: (
        content: $1/4" F"$,
        anchor: "south",
      ))
      resistor(
        "r2",
        (8, -2),
        (8, 2),
        label: (
          content: $qty("2", "ohm")$,
          anchor: "south",
        ),
      )
      wire((5, 2), (10, 2))
      wire((-3, -2), (10, -2))
      node("a", (10, 2), fill: false)
      node("b", (10, -2), fill: false)
      voltage-annotation("a", "b", length: 7em, label: $v(t)$)
      node("", (5, -2))
      node("", (5, 2))
      node("", (8, 2))
      node("", (8, -2))
    })
  ]
]

where
$
  v_(s) = cases(
    t = qty("12", "V")" for" t < 0,
    t = qty("24", "V")" for" t > 0,
  )
$

at $t = 0^(-)$, the circuit is in DC steady state, so the inductor behaves as a short circuit and the capacitor as an open circuit
$
  i_(L)(0^(+) ) = i_(L)(0^(-) ) = 12/(10 + 2) = qty("1", "A")
$
and it follows that the voltage across the capacitor is the voltage across $R_(2)$:
$
  v_(C)(0^(+) ) = i_(L)(0^(+) )R_(2) = qty("2", "V")
$
now we derive the equations for $t>0$. notice:
$
  v_(s) = qty("24", "V")\
  i = i_(C) + i_(R_(2) ) \
  v(t) = v_(C)(t)
$
so,
$
   i & = C v' + 1/R_(2) v \
   i & = 1/4 v' + 1/2 v \
  i' & = 1/4 v'' + 1/2 v'
$
now do a KVL around the leftmost loop:
$
   0 & = 24 - L i' - R_(1)i - v \
  24 & = L i' + R_(1)i + v \
  24 & = 2(1/4 v'' + 1/2 v') + 10(1/4 v' + 1/2 v) + v \
  24 & = 1/2 v'' + v' + 10/4 v' + 5v + v \
  48 & = v'' + 7v' + 12v
$
write the characteristic equation:
$
   s^2 + 7s + 12 & = 0 \
  (s + 3)(s + 4) & =0 \
   s in {-3, -4}
$
two real roots indicate the solution is overdamped. to find the steady-state value of $v(t)$, set the derivatives to $0$ ($v(t)$ stops changing as $t->oo$)
$
  12 v(oo) & = 48 \
     v(oo) & = 4
$
therefore, the solution has the form
$
  v(t) = 4 + A e^(-3t) + B e^(-4t)
$
to find $A$ and $B$, recall that $v(0^(+)) = qty("2", "V")$. at $t = 0$,
$
  4 + A + B & = 2 \
      A + B & = -2
$
and $i(0^(+)) = qty("1", "A")$ :
$
      i & = 1/4 v' + 1/2 v \
      1 & = 1/4 v'(0) + 1/2 (2) \
  v'(0) & =0
$
now differentiate the response and evaluate at $t=0$:
$
  -3 A - 4B & = 0 \
   3 A + 4B & = 0
$
solving the system:
$
  mat(
    1, 1;
    3, 4;
  )mat(A; B) = mat(
    -2;
    0,
  ) \
  mat(A; B) = mat(-8; 6)
$
thus,
$
  boxed(v(t) &= 4 - 8e^(-3t) + 6e^(-4t)" V")" for" t>=0
$

=== Step 2. Simulate the circuit to confirm your result in Step 1.
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_04/part_03.py",
)[View simulation code]
#figure(
  image("../simulations/figures/lab_04/part_03.png"),
  caption: [Simulated output voltage $v(t)$, confirming the overdamped response predicted analytically. The voltage begins at $qty("2", "V")$ and rises monotonically toward its $qty("4", "V")$ steady-state value without overshoot or oscillation.],
)
