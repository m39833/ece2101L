from math import radians

import matplotlib.pyplot as plt
import numpy as np

from simulations.utils import mkfigpath

Vm = 1
Im = 1
theta_v = 0
theta_i = -radians(60)

t = np.linspace(0, 4 * np.pi, 1000)
w = 1

v = Vm * np.cos(w * t + theta_v)
i = Im * np.cos(w * t + theta_i)
p = v * i

plt.plot(t, v, label="$v(t)$", color="blue")
plt.plot(t, i, label="$i(t)$", color="red")
plt.plot(t, p, label="$p(t)$", color="green")

plt.axhline(0, color="black", linewidth=0.8)
plt.xticks(
    [
        0,
        np.pi / 4,
        np.pi / 2,
        3 * np.pi / 4,
        np.pi,
        5 * np.pi / 4,
        3 * np.pi / 2,
        7 * np.pi / 4,
        2 * np.pi,
    ],
    [
        "0",
        r"$\frac{\pi}{4}$",
        r"$\frac{\pi}{2}$",
        r"$\frac{3\pi}{4}$",
        r"$\pi$",
        r"$\frac{5\pi}{4}$",
        r"$\frac{3\pi}{2}$",
        r"$\frac{7\pi}{4}$",
        r"$2\pi$",
    ],
)

plt.xlim(0, 2 * np.pi)
plt.xlabel(r"$\omega t$ (rad)")
plt.xlabel(r"$\omega t$ (radians)")
plt.ylabel("Amplitude")
plt.title("Voltage, Current, and Instantaneous Power")
plt.legend()
plt.grid(True)

plt.savefig(mkfigpath(__file__), dpi=600)
plt.show()
