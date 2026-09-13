import matplotlib.pyplot as plt
import numpy as np
from matplotlib.ticker import MultipleLocator
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_A, u_H, u_mH, u_ms, u_us, u_V, u_Ω

from ..utils import mkfigpath

TIME_TO_SWITCH = 20 @ u_ms

circuit = Circuit("part 2")

circuit.model(
    "SW_HIGH",
    "SW",
    ron=1e-3,
    roff=1e9,
    vt=2.5,
    vh=0.1,
)
circuit.model(
    "SW_LOW",
    "SW",
    ron=1e-3,
    roff=1e9,
    vt=-2.5,
    vh=0.1,
)
circuit.PulseVoltageSource(
    "control",
    "control",
    circuit.gnd,
    initial_value=5 @ u_V,
    pulsed_value=0 @ u_V,
    delay_time=TIME_TO_SWITCH,
    rise_time=1 @ u_us,
    fall_time=1 @ u_us,
    pulse_width=500 @ u_ms,
    period=1000 @ u_ms,
)

circuit.V("", "a", circuit.gnd, 24 @ u_V)
circuit.R("1", "a", "sb-in", 2 @ u_Ω)
circuit.S(
    "b",
    "sb-in",
    "switch-common",
    "control",
    circuit.gnd,
    model="SW_HIGH",
)
circuit.S(
    "a",
    "switch-common",
    "sa-out",
    circuit.gnd,
    "control",
    model="SW_LOW",
)
circuit.L(
    "",
    "switch-common",
    circuit.gnd,
    200 @ u_mH,
)
circuit.R("2", "sa-out", circuit.gnd, 10 @ u_Ω)
circuit.I("", "sa-out", circuit.gnd, 8 @ u_A)

sim = circuit.simulator()
tr = sim.transient(0.1 @ u_ms, 200 @ u_ms + TIME_TO_SWITCH)

t_s = np.asarray(tr.time)
i_L = np.asarray(tr.branches["l"])

# x = np.arange(0, 500, 0.1)
# y = -8 + 20 * np.exp(-50 * x / 1000)
# plt.plot(x, y)

plt.plot(t_s * 1000 - TIME_TO_SWITCH.value, i_L, label="$i(t)$", color="#04ACF3")

plt.xlabel("$t$ (ms)")
plt.ylabel("$i$ (A)")
plt.title("$i$ vs. $t$")

plt.legend()
plt.tight_layout()
plt.gca().yaxis.set_major_locator(MultipleLocator(4))
plt.grid(True)

plt.savefig(mkfigpath(__file__))

plt.show()
