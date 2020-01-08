#!/usr/bin/env python

from __future__ import print_function

import matplotlib.pyplot as plt
import json
import sys


def plot(ax, poly, label_i):
    exterior = poly["exterior"]
    interiors = poly["interiors"]

    xs = [p["x"] for p in exterior]
    ys = [p["y"] for p in exterior]

    ax.plot(xs, ys, "o-", label="Polygon {}".format(label_i + 1))


if len(sys.argv) < 2:
    print("ERROR: Wrong number of arguments.")
    sys.exit(1)

elif len(sys.argv) == 2:
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

elif len(sys.argv) == 3:
    filename_a = sys.argv[1]
    filename_b = sys.argv[2]

    data_a = json.load(open(filename_a))
    data_b = json.load(open(filename_b))

    fig, axes = plt.subplots(1, 3, figsize=(16, 8), sharex=True, sharey=True)

    for data, ax in zip([data_a, data_b], axes[:2]):
        for i, poly in enumerate(data):
            plot(ax, poly, i)

    for i, poly in enumerate(data_a):
        plot(axes[-1], poly, i)
    for i, poly in enumerate(data_b):
        plot(axes[-1], poly, i)

    #plt.legend(loc="best")
    plt.tight_layout()

    #filename_out = filename.replace(".json", ".png")
    #plt.savefig(filename_out)

    plt.show()
