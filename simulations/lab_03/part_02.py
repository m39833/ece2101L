import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_mA, u_mH, u_ms, u_nF, u_uF, u_us, u_V, u_Ω

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 0.5
SIM_DURATION = 3

circuit = Circuit("part 2")

c = circuit.C("", "a", circuit.gnd, 0.1 @ u_uF, initial_condition=100 @ u_V)


add_timed_spdt(
    circuit,
    "1",
    "a",
    "dump",
    "b",
    TIME_TO_SWITCH @ u_ms,
    SIM_DURATION,
)

l = circuit.L("", "b", "c", 100 @ u_mH, initial_condition=0)
r = circuit.R("", "c", circuit.gnd, 560 @ u_Ω)


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
# plt.plot(t * 1000, (1000 / 9600 * 1000) * np.exp(-2800 * t) * np.sin(9600 * t))

plt.legend()
plt.savefig(mkfigpath(__file__))

plt.show()
