import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_kΩ, u_mA, u_mH, u_ms, u_nF, u_uF, u_us, u_V, u_Ω

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 0.5
SIM_DURATION = 3

circuit = Circuit("part 3")

va = circuit.V("a", "out-a", circuit.gnd, 80 @ u_V)
r1 = circuit.R("1", "out-a", "a", 9 @ u_kΩ)
r2 = circuit.R("2", "a", circuit.gnd, 15 @ u_kΩ)

c = circuit.C("", circuit.gnd, "sw", 2 @ u_uF)
add_timed_spdt(
    circuit,
    "1",
    "sw",
    "a",
    "b",
    TIME_TO_SWITCH @ u_ms,
    SIM_DURATION,
)

vb = circuit.V("b", "out-b", circuit.gnd, 100 @ u_V)
l = circuit.L("", "out-b", "out-l", 5 @ u_mH, initial_condition=0)
r3 = circuit.R("3", "out-l", "b", 80 @ u_Ω)


sim = circuit.simulator()
tr = sim.transient(
    1 @ u_us, (SIM_DURATION + TIME_TO_SWITCH) @ u_ms, use_initial_condition=False
)
t = np.asarray(tr.time)
v_C = tr.nodes["sw"]

plt.title("$v_C$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v_C$ (V)")
plt.grid()

plt.plot(t * 1000 - TIME_TO_SWITCH, v_C, label="$v_C (t)$", color="#04ACF3")
# plt.plot(
#     t * 1000,
#     100 - np.exp(-8000 * t) * (200 / 3 * np.sin(6000 * t) + 50 * np.cos(6000 * t)),
# )

plt.legend()
plt.savefig(mkfigpath(__file__))

plt.show()
