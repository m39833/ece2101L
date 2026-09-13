import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_H, u_kΩ, u_mH, u_ms, u_uF, u_us, u_V, u_Ω

from ..utils import mkfigpath

TIME_TO_SWITCH = 100 @ u_ms

circuit = Circuit("part 3")

circuit.PulseVoltageSource(
    "ctl",
    "ctl",
    circuit.gnd,
    delay_time=TIME_TO_SWITCH,
    initial_value=5 @ u_V,
    pulsed_value=0 @ u_V,
    rise_time=1 @ u_us,
    fall_time=1 @ u_us,
    pulse_width=2000 @ u_ms,
    period=4000 @ u_ms,
)
circuit.model("SW_HIGH", "SW", ron=1e-3, roff=1e9, vt=2.5, vh=0.1)
circuit.model("SW_LOW", "SW", ron=1e-3, roff=1e9, vt=-2.5, vh=0.1)

circuit.V("1", circuit.gnd, "tr", 40 @ u_V)
circuit.R("1", "a", "tr", 20 @ u_Ω)
circuit.R("2", "a", circuit.gnd, 60 @ u_Ω)
circuit.S("a", "s-common", "a", "ctl", circuit.gnd, model="SW_HIGH")
circuit.S("b", "s-common", "b", circuit.gnd, "ctl", model="SW_LOW")
circuit.C("", "s-common", circuit.gnd, 0.5 @ u_uF)
circuit.R("3", "tl", "b", 400 @ u_kΩ)
circuit.V("2", "tl", circuit.gnd, 90 @ u_V)

sim = circuit.simulator()
tr = sim.transient(0.1 @ u_ms, 1750 @ u_ms + TIME_TO_SWITCH)
t = np.asarray(tr.time)
v = np.asarray(tr.nodes["s-common"])

plt.plot(t * 1000 - TIME_TO_SWITCH.value, v, label="$v(t)$", color="#04ACF3")

plt.title("$v$ vs. $t$")
plt.xlabel("$t$ (ms)")
plt.ylabel("$v$ (V)")
plt.legend()
plt.gca().yaxis.set_major_locator(MultipleLocator(30))
plt.grid()

plt.savefig(mkfigpath(__file__))

plt.show()
