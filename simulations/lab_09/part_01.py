import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_H, u_ms, u_V, u_Ω

from simulations.constants import ANNOTATION_BLUE

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 500
SIM_DURATION = 4000

circuit = Circuit("part 1")

circuit.V("s", "vout", circuit.gnd, 336 @ u_V)
add_timed_spdt(
    circuit,
    "",
    "vout",
    "dump",
    "a",
    TIME_TO_SWITCH @ u_ms,
    SIM_DURATION,
)
circuit.L("1", "a", "b", 8.4 @ u_H, initial_condition=0)
circuit.R("1", "b", circuit.gnd, 42 @ u_Ω)
circuit.L("2", "b", "c", 10 @ u_H, initial_condition=0)
circuit.R("2", "c", circuit.gnd, 48 @ u_Ω)

sim = circuit.simulator()
tr = sim.transient(1 @ u_ms, SIM_DURATION @ u_ms, use_initial_condition=False)
t = np.asarray(tr.time)
i_L1 = np.asarray(tr.branches["l1"])
i_L2 = np.asarray(tr.branches["l2"])


fig = plt.figure(figsize=(10, 5), layout="constrained")
ax1 = fig.add_subplot(1, 2, 1)
ax2 = fig.add_subplot(1, 2, 2)

ax1.plot(t * 1000 - TIME_TO_SWITCH, i_L1, color=ANNOTATION_BLUE)
ax1.set_title("$i_{L_1}$ vs. $t$")
ax1.set_xlabel("$t$ (ms)")
ax1.set_ylabel("$i_{L_1}$ (A)")
ax1.grid()
ax1.yaxis.set_major_locator(MultipleLocator(3))

ax2.plot(t * 1000 - TIME_TO_SWITCH, i_L2, color=ANNOTATION_BLUE)
ax2.set_title("$i_{L_2}$ vs. $t$")
ax2.set_xlabel("$t$ (ms)")
ax2.set_ylabel("$i_{L_2}$ (A)")
ax2.grid()

fig.savefig(mkfigpath(__file__), dpi=600)

plt.show()
