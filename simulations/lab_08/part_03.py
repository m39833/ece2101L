import numpy as np
from PySpice.Spice.Netlist import Circuit
from PySpice.Unit import u_H, u_Hz, u_Ohm, u_V

from simulations.utils import phasor

f = 60.0
R = 576 / 125
L = (432 / 125) / (2 * np.pi * f)

circuit = Circuit("part 3")

circuit.SinusoidalVoltageSource(
    "s",
    "vin",
    circuit.gnd,
    ac_magnitude=240 @ u_V,
    frequency=f @ u_Hz,
)

circuit.R(1, "vin", "mid", R @ u_Ohm)
circuit.L(1, "mid", circuit.gnd, L @ u_H)

sim = circuit.simulator(temperature=25, nominal_temperature=25)
ac = sim.ac(
    variation="lin",
    number_of_points=1,
    start_frequency=f @ u_Hz,
    stop_frequency=f @ u_Hz,
)

V = phasor(ac.nodes["vin"])
I = -phasor(ac.branches["vs"])
Z = V / I
S = V * I.conjugate()

pf = S.real / abs(S)
arg_I = np.angle(I / V, deg=True)

print(f"Inductance = {L * 1000:.3f} mH")
print(f"Voltage = {abs(V):.2f} V (rms)")
print(f"Current = {I.real:.3f} {I.imag:+.3f}j A")
print(f"|Current| = {abs(I):.3f} A (rms)")
print(f"Current phase relative to voltage = {arg_I:.2f} degrees")
print(f"Complex power = {S.real:.2f} {S.imag:+.2f}j VA")
print(f"Impedance = {Z.real:.3f} {Z.imag:+.3f}j ohm")
print(f"Power factor = {pf:.3f}")

assert np.isclose(S, 8000 + 6000j)
assert np.isclose(Z, 4.608 + 3.456j)
assert np.isclose(pf, 0.8)
