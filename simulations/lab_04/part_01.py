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

SIM_DURATION = 3500

circuit = Circuit("part 1")

circuit.L("", circuit.gnd, "a", 2 @ u_H, initial_condition=1 / 2 @ u_A)
circuit.R("1", "a", "b", 10 @ u_Ω)
circuit.C("", "b", circuit.gnd, 1 / 8 @ u_F, initial_condition=1 @ u_V)
circuit.R("2", "b", circuit.gnd, 8 @ u_Ω)

sim = circuit.simulator()
tr = sim.transient(1 @ u_ms, (SIM_DURATION) @ u_ms, use_initial_condition=True)
t = np.asarray(tr.time)
v = np.asarray(tr.nodes["b"])

plt.title("$v$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v$ (V)")
plt.grid()

plt.plot(t * 1000, v, label="$v (t)$", color="#04ACF3")
# plt.plot(t * 1000, (1 + 6 * t) * np.exp(-3 * t))
plt.legend()
plt.savefig(mkfigpath(__file__))

plt.show()
