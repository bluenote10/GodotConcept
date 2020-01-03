#!/usr/bin/env python

from __future__ import print_function

import matplotlib.pyplot as plt
import json

data = json.load(open("world.json"))

fig, ax = plt.subplots(1, 1, figsize=(10, 8))

for i, poly in enumerate(data):
    exterior = poly["exterior"]
    interiors = poly["interiors"]

    xs = [p["x"] for p in exterior]
    ys = [p["y"] for p in exterior]

    ax.plot(xs, ys, "o-", label="Polygon {}".format(i + 1))

plt.legend(loc="best")
plt.show()