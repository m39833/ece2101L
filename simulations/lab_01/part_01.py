import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_H, u_ms, u_us, u_V, u_Ω

from ..components import add_timed_spdt
from ..utils import mkfigpath

TIME_TO_SWITCH = 50 @ u_ms
SIM_DURATION = 600 @ u_ms

circuit = Circuit("part 1")

circuit.PulseVoltageSource(
    "ctl",
    "ctl",
    circuit.gnd,
    delay_time=TIME_TO_SWITCH,
    initial_value=5 @ u_V,
    pulsed_value=0 @ u_V,
    rise_time=1 @ u_us,
    fall_time=1 @ u_us,
    pulse_width=SIM_DURATION * 2,
    period=SIM_DURATION * 4,
)
circuit.model("SW_HIGH", "SW", ron=1e-3, roff=1e9, vt=2.5, vh=0.1)
circuit.model("SW_LOW", "SW", ron=1e-3, roff=1e9, vt=-2.5, vh=0.1)

circuit.I("", circuit.gnd, "sw", 6.4 @ u_A)
circuit.S("a", "sw", "a", "ctl", circuit.gnd, model="SW_HIGH")
circuit.S("b", "sw", circuit.gnd, circuit.gnd, "ctl", model="SW_LOW")
circuit.R("o", "a", circuit.gnd, 10 @ u_Ω)
circuit.R("1", "a", "b", 6 @ u_Ω)
circuit.L(
    "",
    "b",
    circuit.gnd,
    0.32 @ u_H,
)
circuit.R("2", "b", circuit.gnd, 4 @ u_Ω)

sim = circuit.simulator()
tr = sim.transient(0.1 @ u_ms, SIM_DURATION + TIME_TO_SWITCH)
v_ctl = np.asarray(tr["ctl"])
post_switch = v_ctl < float("inf")
t = np.asarray(tr.time)[post_switch]
v_o = np.asarray(tr.nodes["a"])[post_switch]

plt.plot(t * 1000 - TIME_TO_SWITCH.value, v_o, label="$v_o (t)$", color="#04ACF3")
# plt.plot(t * 1000, -8 * np.exp(-10 * t), color="orange")

plt.title("$v_o$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v_o$ (V)")
plt.legend()
plt.gca().yaxis.set_major_locator(MultipleLocator(4))
plt.grid()

plt.savefig(mkfigpath(__file__))

plt.show()
