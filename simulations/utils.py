from pathlib import Path
from typing import cast

import matplotlib.pyplot as plt
import numpy as np
from matplotlib.figure import Figure
from matplotlib.projections.polar import PolarAxes
from matplotlib.typing import ColorType
from PySpice.Probe.WaveForm import WaveForm

SIMULATIONS_DIR = Path(__file__).resolve().parent
FIGURES_DIR = SIMULATIONS_DIR / "figures"


def phasor(waveform: WaveForm[np.complex128]):
    return complex(np.asarray(waveform).item())


def mkfigpath(source_file: str | Path, suffix: str = ".png") -> Path:
    source = Path(source_file).resolve()
    relative = source.relative_to(SIMULATIONS_DIR).with_suffix(suffix)

    path = FIGURES_DIR / relative
    path.parent.mkdir(parents=True, exist_ok=True)

    print(f"saved figure to {path}")

    return path


COLORS: tuple[str, ...] = (
    "tab:blue",
    "tab:orange",
    "tab:green",
    "tab:red",
    "tab:purple",
    "tab:brown",
)


def draw_phasors(
    phasors: dict[str, complex],
    *,
    ax: PolarAxes,
    unit: str,
    thetamin: float = 0,
    thetamax: float = 360,
    grid_step: int = 30,
    color: ColorType | None = None,
    title: str | None = None,
) -> None:
    ax.set_theta_zero_location("E")
    ax.set_theta_direction(1)
    ax.set_thetamin(thetamin)
    ax.set_thetamax(thetamax)

    ax.set_thetagrids(np.arange(thetamin, thetamax + 1, grid_step))

    largest = max(abs(value) for value in phasors.values())
    radial_limit = largest * 1.3
    ax.set_ylim(0, radial_limit)
    ax.set_axisbelow(True)

    for index, (name, value) in enumerate(phasors.items()):
        color = color or COLORS[index % len(COLORS)]

        magnitude = abs(value)
        angle_rad = float(np.angle(value))
        angle_deg = float(np.angle(value, deg=True))

        annotation = ax.annotate(
            "",
            xy=(angle_rad, magnitude),
            xytext=(0, 0),
            annotation_clip=False,
            zorder=5,
            arrowprops={
                "arrowstyle": "-|>",
                "color": color,
                "linewidth": 2.5,
                "mutation_scale": 25,
                "shrinkA": 0,
                "shrinkB": 0,
            },
        )

        if annotation.arrow_patch is not None:
            annotation.arrow_patch.set_clip_on(False)

        ax.text(
            angle_rad,
            magnitude + radial_limit * 0.06,
            (
                rf"${name}={magnitude:.2f}"
                rf"\angle {angle_deg:.1f}^\circ"
                rf"\,\mathrm{{{unit}}}$"
            ),
            color=color,
        )

    ax.grid(alpha=0.4)
    if title is not None:
        ax.set_title(title, pad=20)
