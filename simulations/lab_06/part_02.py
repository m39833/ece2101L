from math import pi, radians

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.BasicElement import CurrentControlledCurrentSource
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import (
    u_A,
    u_F,
    u_H,
    u_Hz,
    u_kΩ,
    u_mA,
    u_mH,
    u_ms,
    u_nF,
    u_uF,
    u_uH,
    u_us,
    u_V,
    u_Ω,
)

from simulations.constants import ANNOTATION_BLUE, LOOSELY_DASHED

from ..utils import mkfigpath

# period = 1 / (50000 / 2 * pi)
SIM_DURATION = 0.3

circuit = Circuit("part 4")

circuit.B(
    "v1",
    "a",
    circuit.gnd,
    voltage_expression="5*cos(80000*time)",
)
circuit.R("", "a", "b", 20 @ u_Ω)
circuit.L("", "b", circuit.gnd, 125 @ u_uH)
circuit.C("", "b", "c", 1.25 @ u_uF)
circuit.B(
    "v2",
    circuit.gnd,
    "c",
    voltage_expression="-2.5*cos(320000*time)",
)

sim = circuit.simulator()
tr = sim.transient(0.1 @ u_us, SIM_DURATION @ u_ms, use_initial_condition=True)
t = np.asarray(tr.time)
vo = np.asarray(tr.nodes["b"])


plt.title("$v_o$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("voltage (V)")
# plt.gca().yaxis.set_major_locator(MultipleLocator(3))
plt.grid()

plt.plot(
    t * 1000,
    5 * np.cos(80000 * t) + 2.643 * np.cos(320000 * t + radians(7.59)),
    label=r"$v_{o_\text{ss}}$",
)
plt.plot(t * 1000, vo, label="$v_o (t)$", color=ANNOTATION_BLUE)

plt.legend()
plt.savefig(mkfigpath(__file__), dpi=600)

plt.show()
