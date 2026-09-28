import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_mA, u_mH, u_ms, u_nF, u_us, u_V, u_Ω

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 0.25
SIM_DURATION = 1

circuit = Circuit("part 1")

i = circuit.I("", circuit.gnd, "top", 24 @ u_mA)

add_timed_spdt(
    circuit,
    "1",
    "top",
    circuit.gnd,
    "dump-1",
    TIME_TO_SWITCH @ u_ms,
    SIM_DURATION,
)

c = circuit.C("", circuit.gnd, "top", 25 @ u_nF, initial_condition=0 @ u_V)
l = circuit.L("", "top", circuit.gnd, 25 @ u_mH, initial_condition=0 @ u_A)
r = circuit.R("", "top", circuit.gnd, 400 @ u_Ω)


sim = circuit.simulator()
tr = sim.transient(
    1 @ u_us, (SIM_DURATION + TIME_TO_SWITCH) @ u_ms, use_initial_condition=True
)
t = np.asarray(tr.time)
i_L = np.asarray(tr.branches["l"])

plt.title("$i$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$i$ (mA)")
plt.grid()

plt.plot(t * 1000 - TIME_TO_SWITCH, i_L * 1000, label="$i (t)$", color="#04ACF3")
# plt.plot(t * 1000, (24 - 32 * np.exp(-20000 * t) + 8 * np.exp(-80000 * t)))

plt.legend()
plt.savefig(mkfigpath(__file__))

plt.show()
