#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *
#import "@preview/zero:0.7.1": num

#show: report.with(
  title: [Lab 5: Phasors - Part 1],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "September 28, 2026",
  report-date: "October 5, 2026",
)

= No 1.

=== Step 1. Use Phasor Transformation notation to add the two sinusoidal functions shown below:
$
  i(t) = [#math.underbrace($5cos(300t + 36.87 degree)$, $A$) + #math.underbrace($10cos(300t -53.13 degree)$, $B$)]" A"
$
$
  vbold(A) & = 5 angle 36.87 degree \
  vbold(B) & = 10 angle -53.13 degree \
$
$
  vbold(A) & = 5[cos(36.87 degree) + j sin(36.87 degree)] \
  & approx #round3(5 * calc.cos(36.87deg)) +j #round3(5 * calc.sin(36.87deg)) thin "A" \ \
  vbold(B) & = 10[cos(-53.13 degree) + j sin(-53.13 degree)] \
  & approx #round3(10 * calc.cos(-53.13deg)) -j #round3(calc.abs(10 * calc.sin(-53.13deg))) thin "A"
$
$
  vbold(I) = vbold(A) + vbold(B) & = (4 + 6) + j(3 - 8) \
                        vbold(I) & = 10 -j 5
$
$
  abs(vbold(I)) &= sqrt(Re[vbold(I)]^2 + Im[vbold(I)]^2) = #round3(calc.sqrt(calc.pow(10, 2) + calc.pow(5, 2))) \
  theta_(vbold(I)) &= tan^(-1)(Im[vbold(I)]/Re[vbold(I)]) = #round3(calc.atan2(10, -5).deg())degree \
$
therefore,
$
  vbold(I) = 11.18 angle -26.565 degree" A" \
  boxed(i(t) = 11.18 cos(300t -26.565 degree)" A")
$



= No 2.

=== Step 1. Given the circuit below, compute the impedance $Z_(T)$


#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      node("", (-1, 2.5), fill: false)
      node("", (-1, -2.5), fill: false)
      resistor("", (-1, 2.5), (3, 2.5), label: (
        content: $qty("2", "ohm")$,
      ))
      node("a", (3, 2.5))
      inductor("", (3, 0), "a", label: (
        content: $j qty("2", "ohm")$,
        anchor: "south",
      ))
      node("b", (3, -2.5))
      resistor("", "b", (3, 0), label: (
        content: $qty("2", "ohm")$,
        anchor: "south",
      ))
      capacitor(
        "",
        (7, 2.5),
        "a",
        label: (
          content: $-j qty("4", "ohm")$,
          anchor: "south",
        ),
        polarized: true,
      )
      resistor("", (7, 0), (7, 2.5), label: (
        content: $qty("4", "ohm")$,
        anchor: "south",
      ))
      inductor("", (7, -2.5), (7, 0), label: (
        content: $j qty("6", "ohm")$,
        anchor: "south",
      ))
      wire((-1, -2.5), (7, -2.5))
      cetz.draw.line(
        (-1.5, 0),
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
        (-2, 0),
        text(fill: annotation-blue)[
          $Z_(T)$
        ],
        anchor: "center",
      )
    })
  ]
]

$
   Z_("right") & = -j 4 + 4 + j 6 = 4 + j qty("2", "ohm") \
  Z_("center") & = 2 + j qty("2", "ohm") \
$
$
  Z_(T) & = (Z_("right") parallel Z_("center")) + 2 \
        & = (1/(4+j 2) + 1/(2 + j 2))^(-1) + 2 \
        & = 18/13 + j 14/13 + 2 \
$
$
  boxed(Z_(T) & = 44/13 + j 14/13" "Omega approx 3.552 angle 17.65 degree" "Omega, inset: #1em)
$

=== Step 2. Simulate the circuit to confirm your results in Step 1.
#code-link(5, 2)
#figure(
  image("../simulations/figures/lab_05/part_02.png", width: 80%),
  caption: [Comparison of the calculated and simulated real and imaginary components of the input impedance, showing agreement with $Z_(T) = 3.552 angle 17.65degree thin Omega$.],
)

= No 3.

=== Step 1. Determine the time-domain expressions for steady-state value of $v(t)$, $i_(1)(t)$, and $v_(2)(t)$ for the circuit shown below.

#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      isource("i", (-1, -2), (-1, 2), label: (content: $i_(s)$))
      voltage-annotation(
        "i.out",
        "i.in",
        length: 2.5,
        side: "left",
        offset: 2.2em,
      )
      node("a", (3, 2))
      node("b", (3, -2))
      resistor("r", "b", "a", label: (
        content: $qty("10", "ohm")$,
      ))
      current-annotation(
        "r.out",
        "r.in",
        side: "left",
        arrow_offset: 1.5em,
        label: $i_(1)$,
      )
      node("c", (7, 2))
      node("d", (7, -2))
      resistor("", "c", (7, 0), label: (
        content: $qty("6", "ohm")$,
        anchor: "south",
      ))
      inductor("l", (7, 0), "d", label: (
        content: $qty("40", "uH")$,
        anchor: "south",
      ))
      voltage-annotation(
        "l.in",
        "l.out",
        side: "left",
        offset: 1.5em,
        label: $v_(2)$,
        length: 1.5,
      )
      capacitor("", (11, -2), (11, 2), polarized: true, label: (
        content: $qty("1", "uF")$,
      ))
      wire((-1, 2), (11, 2))
      wire((-1, -2), (11, -2))
    })
  ]
]
$
  i_(s)(t) = 8cos(200","000 t)" A"
$

$
  vbold(I)_(s) = 8 angle 0 degree" A", quad omega = num(200000) "rad/s"
$
$
  Z_(L) = j qty("8", "ohm"),quad Z_(C) = -j qty("5", "ohm")
$
$
  Z_("eq") & = (1/Z_(C) + 1/(6 + Z_(L) ) + 1/10)^(-1) \
  Z_("eq") & = (1/(-j 5) + 1/(6 + j 8) + 1/10)^(-1) \
  Z_("eq") & = 4 - j qty("3", "ohm")
$
$
  vbold(V) = vbold(I)_(s) Z_("eq") => vbold(V) = 32 - j qty("24", "V") = 40 angle -36.87 degree thin "V"
$

$
  Z_(R) = (1/Z_(C) + 1/(6 + Z_(L)))^(-1) = 10/3 - j 20/3 thin Omega
$
$
  vbold(I)_(1) & = vbold(I)_(s) ((1/10)/(1/10 + 1/Z_(R) )) \
               & = vbold(I)_(s) (1/(1 + 3/(1 - j 2))) \
               & = vbold(I)_(s) ((1 - j 2)/(4 - j 2))
$
$
  vbold(I)_(1) = 16/5 - j 12/5 thin "A" = 4 angle - 36.87 degree thin "A"
$
$
  vbold(I)_(2) = vbold(V)/(6 + j 8) = -j qty("4", "A") \
  vbold(V)_(2) = vbold(I)_(2)(j 8) = 32 angle 0 degree thin "V"
$

thus,
$
  boxed(
        v(t) & = 40cos(num(200000)t - 36.87 degree)" V" \
    i_(1)(t) & = 4cos(num(200000)t - 36.87 degree)" A" \
    v_(2)(t) & = 32cos(num(200000)t)" V",
    inset: #0.75em
  )
$

=== Step 2. What frequency will cause $i_(s)(t)$ and $v(t)$ to be in-phase in the steady state?

for them to be in phase, set $Im[Sigma Y] = 0$ and solve for $omega$:

$
  sum Y &= 1/Z_(C) + 1/(6 + Z_(L)) + 1/10 \
  sum Y &= j omega C + 1/(6 + j omega L) + 1/10 \
  sum Y &= j omega C + (6 - j omega L)/(6^2 +(omega L)^2 ) + 1/10 \
  sum Y &= j omega C + (6)/(6^2 +(omega L)^2 ) -(j omega L)/(6^2 +(omega L)^2 ) +1/10 \
$

now take the imaginary parts and set their sum equal to 0:
$
  0 & = omega C - (omega L)/(6^2 +(omega L)^2 ) \
$
assuming $omega > 0$:
$
  36 + (omega L)^2 & = L/C \
             omega & = sqrt(L\/C - 36)/L
$

thus,
$
  boxed(omega = num(50000)" rad/s")
$

=== Step 3. Use SPICE software to simulate the circuit and confirm your results in Steps 1-2.
#code-link(5, 3)
#figure(
  [
    #v(1em)
    #scale(image("../simulations/figures/lab_05/part_03.png"), 110%)
    #v(1em)
  ],
  caption: [Comparison of the calculated and simulated steady-state waveforms for $v(t)$, $i_1 (t)$, and $v_2 (t)$ at $omega = num(200000)" rad/s"$, showing agreement in amplitude and phase.],
)

= No 4.

=== Step 1. Determine the time-domain expression for the steady-state value of $v(t)$ for the circuit shown below.
#align(center)[
  #scale(100%)[
    #zap.circuit({
      import zap: *
      cetz.draw.set-style(zap: circuit-defaults)

      isource("", (-1, -1.5), (-1, 1.5), label: (
        content: $i_(s)$,
      ))
      resistor("", (2, -1.5), (2, 1.5), label: (
        content: $qty("5", "ohm")$,
      ))
      voltage-annotation((3.5, 1.5), (3.5, -1.5), length: 2.5, label: $v(t)$)
      capacitor("", (5, -1.5), (5, 1.5), polarized: true, label: (
        content: $qty("9", "uF")$,
        anchor: "south",
      ))
      inductor("", (8, 1.5), (8, -1.5), label: (
        content: $qty("100", "uH")$,
      ))
      resistor("", (8, 1.5), (11, 1.5), label: (
        content: $qty("20", "ohm")$,
      ))
      vsource("", (11, -1.5), (11, 1.5), label: (
        content: $v_(s)$,
        anchor: "south",
      ))
      wire((-1, -1.5), (11, -1.5))
      wire((-1, 1.5), (8, 1.5))
      node("", (2, 1.5))
      node("", (5, 1.5))
      node("", (8, 1.5))
      node("", (2, -1.5))
      node("", (5, -1.5))
      node("", (8, -1.5))
    })
  ]
]
$
  i_(s)(t) = 10cos(num(50000)t)" A" \
  v_(s)(t) = 100sin(num(50000)t)" V" = 100cos(num(50000)t - 90 degree)
$

$
  omega = num(50000)t" rad/s" \
  vbold(I)_(s) = 10 angle 0 degree" A", quad vbold(V)_(s) = 100 angle -90 degree" V"
$
$
  Z_(L) = j qty("5", "ohm") , quad Z_(C) = -j 20/9 thin Omega
$

KCL \@ top node:

$
  0 &= -vbold(I_(s)) + vbold(V)/5 + vbold(V)/Z_(C) + vbold(V)/Z_(L) + (vbold(V) - vbold(V)_(s) )/20 \
  vbold(I)_(s)&= vbold(V)/5 + j ( 9 vbold(V))/20 - j vbold(V)/5 + (vbold(V) - vbold(V)_(s))/20 \
  20 vbold(I)_(s) &= 4 vbold(V) + j 9 vbold(V) - j 4 vbold(V) + vbold(V) -vbold(V)_(s) \
  20vbold(I)_(s) &= vbold(V)(5 + j 5) - vbold(V)_(s) \
$
$
  vbold(V) = (20 vbold(I)_(s) + vbold(V)_(s))/(5 + j 5) \
$
$
  vbold(V) & = (200 - j 100)/(5 + j 5) \
           & = 20 ((2 - j)/(1 + j)) \
           & = 10 - j qty("30", "V") \
           & = 31.623 angle -71.57 degree thin "V"
$
thus,
$
  boxed(v(t) = 31.623cos(num(50000)t - 71.57 degree)thin"V")
$

=== Step 2. Use SPICE software to simulate the circuit and confirm your result in Step 1.
#code-link(5, 4)
#figure(
  scale(image("../simulations/figures/lab_05/part_04.png")),
  caption: [Comparison of the simulated voltage and analytical steady-state response, $v_("ss") = 31.623cos(num(50000)t - 71.57 degree)thin"V"$. The initial transient decays, and the simulated waveform approaches the analytical result.],
)
