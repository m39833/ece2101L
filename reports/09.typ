#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *
#import "@preview/zero:0.7.1": num
#import "@preview/cetz:0.4.2": canvas, draw


#show: report.with(
  title: [Lab 9: The Laplace Transform],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "October 26, 2026",
  report-date: "November 8, 2026",
)

= No 1. <part-1>

#align(center)[
  #zap.circuit({
    import zap: *
    import cetz.draw: content, line
    cetz.draw.set-style(zap: circuit-defaults)

    vsource("", (-1.5, -1.5), (-1.5, 1.5), label: (
      anchor: "south",
      content: $336u(t) thin "V"$,
    ))

    inductor("", (-1.5, 1.5), (3, 1.5), label: $qty("8.4", "H")$)
    resistor("", (3, 1.5), (3, -1.5), label: (content: $qty("42", "ohm")$))
    inductor("", (3, 1.5), (6, 1.5), label: $qty("10", "H")$)
    resistor("", (6, 1.5), (6, -1.5), label: $qty("48", "ohm")$)
    wire((-1.5, -1.5), (6, -1.5))
    node("", (3, 1.5))
    node("", (3, -1.5))
    current-annotation(
      (-1.5, 1.5),
      (3, 1.5),
      side: "right",
      arrow_offset: 8pt,
      label: $i_1$,
    )
    current-annotation(
      (3, 1.5),
      (6, 1.5),
      side: "right",
      arrow_offset: 8pt,
      label: $i_2$,
    )
  })
]

=== Step 1. There is no initial energy stored in this circuit. Find $i_1 (t)$ and $i_2 (t)$ for $t>0$. Use the LT approach.

$
  i_1 (0^(+) ) = i_(2) (0^(+) ) = qty("0", "A")
$
#v(1em)
$
  8.4 (dif i_1 ) / (dif t) + 42(i_1 - i_2 ) = 336 \
  ==>^(cal(L)) quad 8.4 (s I_1 - cancelto(0, i_1 (0^(+) )) ) + 42 (I_1 - I_2 ) = 336/s \
  (8.4 s + 42)I_1 - 42I_2 = 336/s
$
#v(1em)
$
  10 (dif i_2 ) / (dif t) + 48 i_2 - 42(i_1 - i_2 ) = 0 \
  ==>^(cal(L)) quad 10(s I_2 - cancelto(0, i_2 (0^(+) )) ) + 48 I_2 - 42(I_1 - I_2 ) = 0 \
  -42 I_1 + (10s + 90)I_2 = 0
$

from the second equation:

$
  I_2= 42/(10s + 90) I_1
$

substitute into the first equation:

$
  (8.4s + 42)I_1 - 42 (42/(10s + 90) I_1 ) = 336/s \
  [(8.4s + 42)(10s + 90)- 42^2]I_1 = (336(10s + 90))/s \
$

$
  I_1 & = (336(10s + 90))/(s[(8.4s + 42)(10s + 90) - 42^2 ]) \
      & = (336(10s + 90))/(s(84s^2 +1176s + 2016)) \
      & = (336(10s + 90))/(84s (s+2)(s+12)) \
      & = (4(10s + 90))/(s (s+2)(s+12)) \
  I_1 & = (40(s + 9))/(s (s+2)(s+12)) \
$
#v(1em)
$
  I_2 & = 42/(cancel(10s + 90))(cancelto(4, 40(s +9))/(s(s+2)(s+12))) \
  I_2 & = 168/(s(s+2)(s+12))
$
#v(1em)
$
  I_1 = A/s + B/(s + 2) + C/(s + 12) \
  40(s + 9) = A(s + 2)(s + 12) + B s (s + 12) + C s (s + 2)
$

$s = -2 => 280 = -20B => B = -14$

$s = -12 => -120 = 120 C => C = -1$

$=> A = 15$
#v(1em)
$
  I_2 = A/s + B/(s + 2) + C/(s + 12) \
  168 = A(s + 2)(s + 12) + B s (s + 12) + C s (s + 2)
$

$s = -2 => 168 = -20B => B = -8.4$

$s = -12 => 168 = 120C => C = 1.4$

$=> A = 7$
#v(1em)
$
  I_1 = 15/s - 14/(s + 2) - 1/(s + 12), quad I_2 = 7/s - 8.4/(s+2) + 1.4/(s + 12)
$

taking the inverse laplace transform for both:
$
  boxed(
    i_1 (t) & = 15 - 14e^(-2t) - e^(-12t) thin "A" thin      & \, quad "for" t>= 0 \
    i_2 (t) & = 7 - 8.4 e^(-2t) + 1.4 e^(-12t) thin "A" thin & \, quad "for" t>= 0
    , inset: #1em
  )
$

=== Step 2. Identify the forced and natural responses. <part1-2>

the forced responses are the steady-state constants:
$
  i_(1 f)(t) = qty("15", "A"), quad i_(2 f)(t) = qty("7", "A")
$

while the natural responses refer to the decaying exponential terms:
$
  i_(1 n)(t) = -14 e^(-2t) - e^(-12t), quad i_(2 n)(t) = -8.4 e^(-2t) + 1.4 e^(-12t)
$

=== Step 3. Simulate the circuit to confirm your results in Step 1.
#code-link(9, 1)

#figure(
  image("../simulations/figures/lab_09/part_01.png"),
  caption: [Simulated inductor currents $i_1 (t)$ and $i_2 (t)$ following application of
    the $qty("336", "V")$ step input. Both currents rise from zero and approach the manually
    calculated steady-state values of $qty("15", "A")$ and $qty("7", "A")$, respectively. The exponential
    rise closely matches the analytical solutions.],
)

= No 2.

$
  F(s) = (10s)/(s^2 +2s + 5)
$

=== Step 1. Find $f(t)$ for $t >= 0$

$
  F(s) & = (10s)/(s^2 +2s + 1 + 5 - 1 ) \
       & = (10s)/((s + 1)^2 + 2^2 ) \
       & = (10(s + 1 - 1))/((s + 1)^2 + 2^2 ) \
       & = 10[(s + 1)/((s + 1)^2 + 2^2 ) - 1/((s + 1)^2 + 2^2 )] \
       & = 10[(s + 1)/((s + 1)^2 + 2^2 )] - 5 [2/((s + 1)^2 + 2^2 ) ] \
$
$
  ==>^(cal(L)^(-1) ) quad boxed(f(t) = 10 e^(-t)cos(2t) - 5e^(-t)sin(2t) thin\, quad "for" t>= 0, inset: #0.8em)
$

= No 3.

$
  F(s) = (70s - 268125)/((s + 875 - j 3000)(s + 875 + j 3000))
$

=== Step 1.

$
  F(s) & = (70s - 268125)/((s + 875)^2 + 3000^2 )
$

rewrite numerator:
$
  70s - 268125 = 70(s + 875) + x \
  x = -329375
$
#v(1em)
$
  F(s) = (70(s + 875) - 329375)/((s + 875)^2 + 3000^2 ) \
  F(s) = 70 [(s + 875)/((s + 875)^2 +3000^2 )] - 329375/3000 [3000/((s + 875)^2 +3000^2 )]
$

$
  ==>^(cal(L)^(-1) ) quad f(t) = 70 e^(-875t)cos(3000t) - 2635/24 e^(-875t) sin(3000t), quad "for" t>= 0 \
  boxed(f(t) = e^(-875t)[70 cos(3000t) - 2635/24 sin(3000t)]\, quad "for" t>= 0, inset: #1em)
$

= No 4.

$
  F(s) = 768/(s^2 + 6s + 25)^2 = (768)/((s + 3 - j 4)^2 (s + 3 + j 4)^2 )
$

=== Step 1. Find the partial fraction expansion when there are repeated complex conjugate roots.

$
  F(s) = A/(s + 3 - j 4) + B/((s + 3 - j 4)^2 ) + C/(s + 3 + j 4) + D/(s + 3 + j 4)^2
$

let $p = -3 + j 4$, $q = -3 - j 4$

$
  768/((s - p)^2 (s - q)^2) &= A/(s - p) + B/(s-p)^2 +C/(s-q)+D/(s-q)^2 \
  768/((s - q)^2) &= A(s - p) + B+C(s - p)^2 /(s-q)+D(s - p)^2 /(s-q)^2 \
$

setting $s = p$:
$
  768/(p - q)^2 = B => B = 768/((j 8)^2 ) => B = -12
$

differentiating both sides and setting $s = p$:
$
  - 1536/(p - q)^3 = A => A = - 1536/(j 8)^3 => A = -3 j
$

$C$ and $D$ are obtained by taking the complex conjugates of $A$ and $B$

$
  C = A^(*) = 3j \
  D = B^(*) = -12
$

so,

$
  boxed(
    F(s) = - (3 j)/(s + 3 - j 4) - 12/(s + 3 - j 4)^2 + (3j)/(s + 3 + j 4) - 12/(s + 3 + j 4)^2, inset: #1em
  )
$

= No 5.

this is a duplicate of #link(<part-1>)[No 1], with the exception of an added #link(<part1-2>)[Step 2], which is addressed in No 1.
