import numpy as np
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_H, u_Hz, u_Ohm, u_V

from simulations.utils import phasor

f = 60.0
circuit = Circuit("part 2")

circuit.SinusoidalVoltageSource(
    "s",
    "source",
    circuit.gnd,
    ac_magnitude=250 @ u_V,  # rms
    frequency=f @ u_Hz,
)

circuit.R("line", "source", "mid", 1 @ u_Ohm)
circuit.L("line", "mid", "load", (4 / (2 * np.pi * f)) @ u_H)

circuit.R("load", "load", "rl", 39 @ u_Ohm)
circuit.L("load", "rl", circuit.gnd, (26 / (2 * np.pi * f)) @ u_H)

sim = circuit.simulator(temperature=25, nominal_temperature=25)
ac = sim.ac(
    variation="lin",
    number_of_points=1,
    start_frequency=f @ u_Hz,
    stop_frequency=f @ u_Hz,
)


Vs = phasor(ac.nodes["source"])
VL = phasor(ac.nodes["load"])

Is = phasor(ac.branches["vs"])
IL = -Is

S_source = Vs * Is.conjugate()
S_line = (Vs - VL) * IL.conjugate()
S_load = VL * IL.conjugate()
S_sum = S_source + S_line + S_load


def show(name: str, value: complex, unit: str):
    print(
        f"{name}: {value.real:.2f} {value.imag:+.2f}j {unit}"
        + f" = {abs(value):.2f} ∠ {np.angle(value, deg=True):.2f}° {unit}"
    )


show("V_L", VL, "V")
show("I_L", IL, "A")

for name, value in (
    ("S_s (absorbed)", S_source),
    ("S_line", S_line),
    ("S_load", S_load),
    ("Power balance", S_sum),
):
    print(f"{name}: {value.real:.2f} {value.imag:+.2f}j VA")

assert np.isclose(VL, 234 - 13j)
assert np.isclose(IL, 4 - 3j)
assert np.isclose(S_sum, 0)
