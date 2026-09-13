import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_mH, u_ms, u_V, u_Ω

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 25
SIM_DURATION = 200

circuit = Circuit("part 1")

circuit.V("", "v-pos", circuit.gnd, 60 @ u_V)
circuit.R("1", "v-pos", "a", 4 @ u_Ω)
circuit.R("2", "a", circuit.gnd, 12 @ u_Ω)

add_timed_spdt(
    circuit,
    "1",
    "a",
    "b",
    "dump-1",
    TIME_TO_SWITCH @ u_ms,
    SIM_DURATION,
)

circuit.R("3", "b", circuit.gnd, 6 @ u_Ω)
circuit.R("4", "b", "c", 3 @ u_Ω)
circuit.L("", "c", circuit.gnd, 150 @ u_mH)

add_timed_spdt(
    circuit,
    "2",
    "c",
    "d",
    "dump-2",
    (TIME_TO_SWITCH + 35) @ u_ms,
    SIM_DURATION,
)

circuit.R("5", "d", circuit.gnd, 18 @ u_Ω)

print(circuit)
sim = circuit.simulator()
tr = sim.transient(1 @ u_ms, SIM_DURATION @ u_ms)
t = np.asarray(tr.time)
i_L = np.asarray(tr.branches["l"])
v_L = np.asarray(tr.nodes["c"])


# plt.style.use("dark_background")
plt.title("$v_L$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v_L$ (V)")
# plt.gca().yaxis.set_major_locator(MultipleLocator(4))
plt.grid()

plt.axvline(35, linestyle="--", label=r"$t=35\text{ ms}$", color="lightgray")

# plt.ylabel("$i_L$ (A)")
# plt.plot(t * 1000 - TIME_TO_SWITCH, i_L, label="$i_L (t)$", color="#04ACF3")

plt.plot(t * 1000 - TIME_TO_SWITCH, v_L, label="$v_L (t)$", color="#04ACF3")

# plt.plot(t * 1000, -36 * np.exp(-40 * t), label="1")
# plt.plot(t * 1000, -13.31 * np.exp(-60 * (t - 0.035)), label="2")
# plt.plot(t * 1000, -54 * np.exp(-60 * (t - 0.035) - 1.4), label="2")
# plt.plot(t * 1000, -54 * np.exp(-60 * t + 0.7), label="2")


plt.legend()
plt.savefig(mkfigpath(__file__))

plt.show()
