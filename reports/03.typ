#import "page-setup.typ": report
#import "@preview/unify:0.8.1": qty
#import "@preview/zap:0.6.0"
#import "lib/index.typ": *

#show: report.with(
  title: [Lab 3: RLC Circuits - Part 1],
  authors: (
    "Matthew Ponciano",
    "Eli Pantoja",
  ),
  // date: datetime.today().display("[month repr:long] [day], [year]"),
  lab-date: "September 14, 2026",
  report-date: "September 21, 2026",
)

= No 1.

=== Step 1. There is no initial energy stored in this circuit. find $i(t)$ for $t >= 0$.

#let flip1 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  isource("i", (-1.5, -1.5), (-1.5, 1.5), label: (
    content: $qty("24", "mA")$,
  ))
  wire((-1.5, 1.5), (1.5, 1.5))
  wire((1.5, 1.5), (1.5, -1.5))
  wire((1.5, -1.5), (-1.5, -1.5))
})

#let flip2 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  isource("i", (-2, -1.5), (-2, 1.5), label: (
    content: $qty("24", "mA")$,
  ))
  wire((-2, 1.5), (8, 1.5))
  wire((-2, -1.5), (8, -1.5))
  node("a", (8, 1.5), fill: false)
  node("b", (8, -1.5), fill: false)
  voltage-annotation("a", "b", label: $v$, length: 6em)
  capacitor("c", (.5, -1.5), (.5, 1.5), polarized: true, label: (
    content: $qty("25", "nF")$,
  ))
  node("c", (.5, 1.5))
  node("c", (.5, -1.5))
  inductor("l", (3, 1.5), (3, -1.5), label: (
    content: $qty("25", "mH")$,
  ))
  node("c", (3, 1.5))
  node("c", (3, -1.5))
  current-annotation(
    (3, 1.5),
    (3, -1.5),
    side: "right",
    label: $i(t)$,
    arrow_offset: 0.5em,
  )
  node("c", (5.5, 1.5))
  node("c", (5.5, -1.5))
  resistor("r", (5.5, 1.5), (5.5, -1.5), label: (
    content: $qty("400", "ohm")$,
  ))
})

#align(center)[
  #move(dx: -2em)[
    #scale(95%, reflow: true)[
      #grid(
        columns: (auto, auto),
        column-gutter: 5em,
        align: center + horizon,

        align(center)[
          #flip1
          #move()[$t = 0^(-)$]
        ],

        align(center)[
          #flip2
          #move()[$t = 0^(+)$]
        ],
      )
    ]
  ]
]

$
  v(0^(+)) = v_(C)(0^(+) ) = v_(C)(0^(-) ) = qty("0", "V") \
$

$
  i_(s) & = i_(C) + i_(L) + i_(R) \
  i_(s) & = C (dif v ) / (dif t) + i_(L) + v/R \
  0 & = C (dif^2 v) / (dif t^2 ) + (dif i_(L) ) / (dif t) + 1/R (dif v) / (dif t) \
  0 & = C (dif^2 v) / (dif t^2 ) + 1/L v + 1/R (dif v) / (dif t) \
  0 & = (dif^2 v) / (dif t^2 ) + 1/(R C) (dif v) / (dif t) + 1/(L C) v \
  0 & = v'' + 1/(R C) v' + 1/(L C) v
$

recall for a parallel RLC system:

$
  v'' + 2alpha v' + omega_(o)^2 v = 0
$

so,

$
  alpha = 1/(2R C) " and " omega_(0) = 1/sqrt(L C) \
  alpha = qty("50000", "s^-1") " and " omega_(0) = 40000" rad/s"
$

and since $alpha > omega_(0)$, the system is overdamped, which implies

$
  s in -alpha plus.minus sqrt(alpha^2 -omega_(0)^2) \
  s in {-20000, -80000}
$

recall the solution is of the form

$
  v(t) = A e^(s_(1)t ) + B e^(s_(2)t )
$

so

$
  v(t) = A e^(-20000t) + B e^(-80000t)" V"
$

to find $A$ and $B$, use the initial condition $v(0^(+)) = 0$, which implies

$
  A + B = 0
$

and the KCL equation at $t = 0^(+)$. since both $v(0^(+))$ and $i_(L) (0^(+))$ are $0$,

$
            qty("24", "mA") & = (qty("25", "nF")) (dif v(0^(+) )) / (dif t) \
  (dif v(0^(+) )) / (dif t) & = qty("24", "mA")/(qty("25", "nF")) \
  (dif v(0^(+) )) / (dif t) & = 960000" V/s".
$

differentiating the solution,
$
  v'(t) = -20000 A e^(-20000t) - 80000 B e^(-80000t)
$

and at $t=0$,

$
  -20000 A - 80000 B = 960000.
$

solving the system yields
$
  mat(
    1, 1;
    -20000, -80000;
  )mat(A; B) = mat(
    0;
    960000,
  )
$

$
  mat(A; B) = mat(16; -16).
$

thus,

$
  v(t) = 16e^(-20000t) - 16e^(-80000t)" V"" for" t>=0
$

now recall

$
  i_(L)(t) = 1/L integral_(0)^(t) v(tau) dif tau + i_(L) (0^(+) )
$

integrating

$
  i_(L)(t) & = 16/L integral_(0)^(t) e^(-20000 tau) -e^(-80000tau ) dif tau + 0 \
$

we obtain
$
  boxed(i_(L)(t) & = 24 - 32 e^(-20000t) + 8e^(-80000t)" mA")" for" t>=0
$




=== Step 2. Simulate the circuit to confirm your result in Step 1.
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_03/part_01.py",
)[View simulation code]

#figure(
  image("../simulations/figures/lab_03/part_01.png"),
  caption: [Simulated inductor current $i(t)$, confirming the overdamped response predicted analytically. The current begins at $qty("0", "mA")$ and approaches the steady-state value of $qty("24", "mA")$ without oscillation.],
)


= No 2.

=== Step 1. The capacitor is charged to $qty("100", "V")$ and at $t=0$, the switch closes. Find $i(t)$ for $t >= 0$.

#let flip1 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  capacitor("c", (-1, -1.5), (-1, 1.5), polarized: true, label: (
    content: $qty("0.1", "uF")$,
    anchor: "south",
  ))
  voltage-annotation(
    "c.out",
    "c.in",
    offset: 2.5em,
    label: $qty("100", "V")$,
    color: color.black,
  )
})


#let flip2 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  capacitor("c", (-1, -1.5), (-1, 1.5), polarized: true, label: (
    content: $qty("0.1", "uF")$,
    anchor: "south",
  ))
  voltage-annotation(
    "c.out",
    "c.in",
    offset: 2.5em,
    label: $qty("100", "V")$,
    color: color.black,
  )
  wire((-1, 1.5), (2, 1.5))
  inductor("l", (2, 1.5), (5.5, 1.5), label: (
    content: $qty("100", "mH")$,
  ))
  resistor("r", (5.5, 1.5), (5.5, -1.5), label: (
    content: $qty("560", "ohm")$,
  ))
  wire((5.5, -1.5), (-1, -1.5))
  node("a", (2.25, 1.5))
  node("b", (2.25, -1.5))
  voltage-annotation(
    (2.25, 1.5),
    (2.25, -1.5),
    label: $v_C$,
  )
  circular-current(
    "mesh-i1",
    (4, 0),
    label: $i$,
    direction: "cw",
    spacing: 1.25em,
  )
})

#align(center)[
  #move(dx: 2em)[
    #grid(
      columns: (auto, auto),
      rows: (auto, auto),
      column-gutter: 3.5em,
      row-gutter: 0.7em,

      grid.cell(
        x: 0,
        y: 0,
        align: center + bottom,
      )[#flip1],

      grid.cell(
        x: 1,
        y: 0,
        align: center + bottom,
      )[#flip2],

      grid.cell(
        x: 0,
        y: 1,
        align: center + horizon,
      )[
        #move()[$t = 0^(-)$]
      ],

      grid.cell(
        x: 1,
        y: 1,
        align: center + horizon,
      )[
        $t = 0^(+)$
      ],
    )
  ]
]

$
  i(0^(+)) = i_(L)(0^(+) ) = i_(L)(0^(-) ) = qty("0", "A") \
  => v_(C)(0^(+) ) = qty("100", "V")
$

$
                   v_(C) & = v_(L) + v_(R) \
                   v_(C) & = L (dif i) / (dif t) + R i \
  (dif v_(C) ) / (dif t) & = L (dif^2 i) / (dif t) + R (dif i) / (dif t) \
$
since $i$ flows out the capacitor's positive terminal, $i = -C (dif v_(C) ) / (dif t)$
$
  -1/C i & = L (dif^2 i) / (dif t) + (dif i) / (dif t) R \
       0 & = (dif^2 i) / (dif t) + R/L (dif i) / (dif t) + 1/(L C) i \
       0 & = i'' + R/L i' + 1/(L C) i \
$

recall for a series RLC system:

$
  i'' + 2alpha i' + omega_(o)^2 i = 0
$

so,

$
  alpha = R/(2L) " and " omega_(0) = 1/sqrt(L C) \
  alpha = qty("2800", "s^-1") " and " omega_(0) = 10000" rad/s"
$

and since $alpha < omega_(0)$, the system is underdamped, which implies the solution is of shape

$
  i(t) = e^(-alpha t) [A cos(omega_(d) t) + B sin(omega_(d) t)]
$

where

$
  omega_(d) = sqrt(omega_(0)^2 - alpha^2) = 9600
$

so

$
  i(t) = e^(-2800 t) [A cos(9600 t) + B sin(9600 t)]
$

now solve for $A$ and $B$ by setting $t = 0$. since $i(0^(+)) = i(0^(-) )$,

$
  A = 0
$

looking at the KVL equation at $t = 0^(+)$

$
            qty("100", "V") & = (qty("100", "mH")) (dif i(0^(+) )) / (dif t) \
  (dif i(0^(+) )) / (dif t) & = 1000 "A/s"
$

differentiating the solution and evaluating at 0 yields

$
  i'(0) = 9600B \
  B = 1000/9600 approx #round3(1000 / 9600 * 1000)" mA"
$

thus,

$
  boxed(i(t) = 1000/9600 e^(-2800 t) sin(9600t)" A", inset: #0.8em)" for" t >= 0
$

=== Step 2. Simulate the circuit to confirm your result in Step 1.
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_03/part_02.py",
)[View simulation code]

#figure(
  image("../simulations/figures/lab_03/part_02.png"),
  caption: [Simulated loop current $i(t)$, showing the expected underdamped natural response of the series RLC circuit. The current starts at zero, oscillates with exponentially decreasing amplitude, and eventually decays back to $qty("0", "A")$ as the initially stored capacitor energy is dissipated by the resistor.],
)

= No 3.

=== Step 1. Find $v_(C)(t)$ for $t >= 0$

#let flip1 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  vsource("va", (-1.5, -1.5), (-1.5, 1.5), label: (
    content: $qty("80", "V")$,
  ))
  resistor("r1", (-1.5, 1.5), (1.5, 1.5), label: (
    content: $9" "upright(k) Omega$,
  ))
  resistor("r2", (1.5, 1.5), (1.5, -1.5), label: (
    content: $15" "upright(k) Omega$,
  ))
  // capacitor("c", (4.5, -1.5), (4.5, 1.5), polarized: true, label: (
  //   content: $qty("2", "uF")$,
  //   anchor: "south",
  // ))
  wire((1.5, 1.5), (4.5, 1.5))
  wire((-1.5, -1.5), (4.5, -1.5))
  node("a", (1.5, 1.5))
  node("a", (1.5, -1.5))
  node("o1", (4.5, -1.5), fill: false)
  node("o2", (4.5, 1.5), fill: false)
  voltage-annotation("o2", "o1", label: $v_(C)$)
})

#let flip2 = zap.circuit({
  import zap: *
  cetz.draw.set-style(zap: circuit-defaults)

  capacitor("c", (-1.5, -1.5), (-1.5, 1.5), polarized: true, label: (
    content: $qty("2", "uF")$,
    anchor: "south",
  ))
  voltage-annotation("c.out", "c.in", offset: 2em, label: $v_(C)$)
  resistor("r3", (-1.5, 1.5), (1.5, 1.5), label: (
    content: $qty("80", "ohm")$,
  ))
  inductor("l", (1.5, 1.5), (4.5, 1.5), label: (
    content: $qty("5", "mH")$,
  ))
  current-annotation(
    (4.5, 1.5),
    (-1.5, 1.5),
    arrow_offset: 1em,
    side: "left",
    label: $i$,
  )
  vsource("vb", (4.5, -1.5), (4.5, 1.5), label: (
    content: $qty("100", "V")$,
  ))
  wire((-1.5, -1.5), (4.5, -1.5))
})

#align(center)[
  #move(dx: 2em)[
    #grid(
      columns: (auto, auto),
      rows: (auto, auto),
      column-gutter: 3.5em,
      row-gutter: 0.7em,

      grid.cell(
        x: 0,
        y: 0,
        align: center + bottom,
      )[#flip1],

      grid.cell(
        x: 1,
        y: 0,
        align: center + bottom,
      )[#flip2],

      grid.cell(
        x: 0,
        y: 1,
        align: center + horizon,
      )[
        #move()[$t = 0^(-)$]
      ],

      grid.cell(
        x: 1,
        y: 1,
        align: center + horizon,
      )[
        $t = 0^(+)$
      ],
    )
  ]
]

find $v_(C)(0^(-) )$ using voltage division:

$
  v_(C)(0^(-) ) = (qty("80", "V")) (15" "upright(k) Omega)/(15" "upright(k) Omega + 9" "upright(k) Omega) = qty("50", "V")
$

then, by continuity,

$
  v_(C)(0^(+) ) = v_(C)(0^(-) ) = qty("50", "V")
$

the inductor branch was open before switching, so

$
  i(0^(-) ) = qty("0", "A")
$

and therefore,

$
  i(0^(+) ) = i(0^(-) ) = qty("0", "A").
$

now construct the differential equation:

$
                                                      v_(L) +v_(R)+ v_(C) & = 100 \
                                        L (dif i) / (dif t) + R i + v_(C) & = 100 \
  L (dif^2 i) / (dif t^2 ) + R (dif i) / (dif t) + (dif v_(C) ) / (dif t) & = 0 \
                   L (dif^2 i) / (dif t^2 ) + R (dif i) / (dif t) + 1/C i & = 0 \
                                                  i'' + R/L i' + 1/(L C)i & = 0 \
$

$
  i'' + R/L i' + 1/(L C) i = 0 " " <==> " " i'' + 2alpha i' + omega_(0)^2 i = 0
$

$
  & => alpha = R/(2L) = qty("8000", "1/s") \
  & => omega_(0) = 1/sqrt(L C) = 10000 "rad/s"
$

since $alpha < omega_(0)$, the system is underdamped, which implies the solution is of shape

$
  i(t) ~ e^(-alpha t) [ A cos(omega_(d) t) + B sin(omega_(d) t) ], "  " omega_(d) =sqrt(omega_(0)^2 - alpha^2)
$


recall $i(0^(+)) = qty("0", "A")$; substituting into $i(t)$ yields
$
  A = 0
$

now find $i'(t)$ at $t = 0^(+)$:
$
  L (dif i(0^(+) )) / (dif t) + cancelto(0, i R) + cancelto(50, v_(C)) & = 100 \
  i'(0^(+) ) &= 50/(qty("5", "mH")) \
  i'(0^(+) ) &= 10000 "A/s"
$

differentiating and evaluating $i(t)$ at $t = 0$ yields
$
  i'(0^(+) ) = -alpha A + omega_(d) B
$

and since $A = 0$,
$
  B & = (i'(0^(+) ))/omega_(d) \
  B & = 5/3 approx qty("1.667", "A")
$

so the current around the RLC loop is
$
  i(t) = 5/3 e^(-8000 t) sin(6000t)" A for" t >= 0
$

to find $v_(C)(t)$, recall that
$
  v_(C)(t)= 1/C integral_(0)^(t) i(tau) dif tau + v_(C)(0^(+) )
$

so we evaluate
$
  v_(C)(t) & = 1/C integral_(0)^(t) 5/3 e^(-8000tau) sin(6000tau) dif tau + 50 \
           & = 5/(3 C) integral_(0)^(t) e^(-8000tau) sin(6000tau) dif tau + 50
$

recall
$
  integral e^(a t) sin(b t) dif t = (e^(a t))/(a^2 + b^2 ) [a sin(b t) - b cos(b t)]
$

so,
$
  v_(C)(t) &= 5/(3 C) [(e^(-8000 tau))/((-8000)^2 + (6000)^2 ) (-8000 sin(6000tau) - 6000 cos(6000tau)) ]_(0)^(t) + 50 \
  &= 5/(3(10^(8) )C) [e^(-8000 t) (-8000sin(6000 t) - 6000 cos(6000 t)) + 6000 ] + 50 \
  &= 50 + 50 + e^(-8000 t) [-200/3 sin(6000t) - 50cos(6000t)]
$

thus,
$
  boxed(v_(C)(t) = 100 - e^(-8000t) [ 200/3 sin(6000t) + 50cos(6000t) ]" V", inset: #0.8em) "for" t>=0
$

=== Step 2. Simulate the circuit to confirm the result in Step 1.
#link(
  "https://github.com/m39833/ece2101L/blob/main/simulations/lab_03/part_03.py",
)[View simulation code]

#figure(
  image("../simulations/figures/lab_03/part_03.png"),
  caption: [Simulated capacitor voltage $v_(C) (t)$, confirming the underdamped transient predicted from the analytical solution. The voltage begins at $qty("50", "V")$, briefly overshoots the final value due to the exchange of energy between the capacitor and inductor, and settles to $qty("100", "V")$.],
)
