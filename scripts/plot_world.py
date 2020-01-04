#!/usr/bin/env python

from __future__ import print_function

import matplotlib.pyplot as plt
import json
import sys


if len(sys.argv) != 2:
    print("ERROR: Wrong number of arguments.")
    sys.exit(1)

else:
    filename = sys.argv[1]

    data = json.load(open(filename))

    fig, ax = plt.subplots(1, 1, figsize=(10, 8))

    for i, poly in enumerate(data):
        exterior = poly["exterior"]
        interiors = poly["interiors"]

        xs = [p["x"] for p in exterior]
        ys = [p["y"] for p in exterior]

        ax.plot(xs, ys, "o-", label="Polygon {}".format(i + 1))

    plt.legend(loc="best")
    plt.tight_layout()

    filename_out = filename.replace(".json", ".png")
    plt.savefig(filename_out)

    plt.show()