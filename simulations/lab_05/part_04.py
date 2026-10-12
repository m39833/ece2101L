from math import pi

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

period = 1 / (50000 / 2 * pi)
SIM_DURATION = 5 * period * 10000

circuit = Circuit("part 4")

circuit.B(
    "i_s",
    circuit.gnd,
    "a",
    current_expression="10*cos(50000*time)",
)
circuit.R("1", "a", circuit.gnd, 5 @ u_Ω)
circuit.C("", "a", circuit.gnd, 9 @ u_uF)
circuit.L("", "a", circuit.gnd, 100 @ u_uH)
circuit.R("2", "a", "b", 20 @ u_Ω)
circuit.B(
    "v_s",
    "b",
    circuit.gnd,
    voltage_expression="100*sin(50000*time)",
)

sim = circuit.simulator()
tr = sim.transient(1 @ u_us, SIM_DURATION @ u_ms, use_initial_condition=True)
t = np.asarray(tr.time)
v = np.asarray(tr.nodes["a"])


plt.title("$v$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("voltage (V)")
# plt.gca().yaxis.set_major_locator(MultipleLocator(3))
plt.grid()

plt.plot(
    t * 1000,
    31.62 * np.cos(50000 * t - (31 * np.pi / 80)),
    # linestyle=LOOSELY_DASHED,
    label=r"$v_{\text{ss}}(t)$",
)
plt.plot(t * 1000, v, label="$v (t)$", color=ANNOTATION_BLUE)

plt.legend()
plt.savefig(mkfigpath(__file__), dpi=600)

plt.show()
