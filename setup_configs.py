#!/usr/bin/env python

import os
import subprocess

script_path = os.path.realpath(__file__)
script_folder = os.path.dirname(script_path)
os.chdir(script_folder)

home_folder = os.path.expanduser("~") + "/"
conf_folder = os.path.realpath(".") + "/"
lnsfv = ["ln", "-sfv"]
mkdir = ["mkdir"]


def link_files(folder):
    for entry in os.walk(folder):
        dirpath, dirnames, filenames = entry
        dirpath += "/"
        for d in dirnames:
            path = home_folder + dirpath + d
            if not os.path.exists(path):
                subprocess.run(mkdir + [path])

        for f in filenames:
            subprocess.run(
                lnsfv + [conf_folder + dirpath + f, home_folder + dirpath + f]
            )


if __name__ == "__main__":
    link_files(".config")
    link_files(".local")
