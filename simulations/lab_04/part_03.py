import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import (
    u_A,
    u_F,
    u_H,
    u_kΩ,
    u_mA,
    u_mH,
    u_ms,
    u_nF,
    u_uF,
    u_us,
    u_V,
    u_Ω,
)

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 200
SIM_DURATION = 3000

circuit = Circuit("part 3")

circuit.V("1", "b", circuit.gnd, 24 @ u_V)
circuit.V("2", "a", circuit.gnd, 12 @ u_V)
add_timed_spdt(
    circuit,
    "sw",
    "c",
    "a",
    "b",
    TIME_TO_SWITCH @ u_ms,
    SIM_DURATION,
)
circuit.L("", "c", "d", 2 @ u_H)
circuit.R("1", "d", "e", 10 @ u_Ω)
circuit.C("", "e", circuit.gnd, 1 / 4 @ u_F)
circuit.R("2", "e", circuit.gnd, 2 @ u_Ω)


sim = circuit.simulator()
tr = sim.transient(1 @ u_ms, (TIME_TO_SWITCH + SIM_DURATION) @ u_ms)
t = np.asarray(tr.time)
v = np.asarray(tr.nodes["e"])

plt.title("$v$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v$ (V)")
plt.grid()

plt.plot(t * 1000 - TIME_TO_SWITCH, v, label="$v (t)$", color="#04ACF3")
# plt.plot(t * 1000, 4 - 8 * np.exp(-3 * t) + 6 * np.exp(-4 * t))

plt.legend()
plt.savefig(mkfigpath(__file__))

plt.show()
