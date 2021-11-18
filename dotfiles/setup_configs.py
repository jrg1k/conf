#!/usr/bin/env python

import os
import subprocess

script_path = os.path.realpath(__file__)
script_folder = os.path.dirname(script_path)
os.chdir(script_folder)

home_folder = os.path.expanduser("~")
conf_folder = os.path.realpath(".")
lnsfv = ["ln", "-sfv"]
mkdir = ["mkdir"]


def link_files(dry_run=False):
    for dirpath, dirnames, filenames in os.walk("."):
        if dirpath == ".":
            filenames.remove(os.path.basename(__file__))
        homepath = f"{home_folder}{dirpath[1:]}/"
        confpath = f"{conf_folder}{dirpath[1:]}/"
        for d in dirnames:
            if not os.path.exists(homepath + d):
                cmd = mkdir + [homepath + d]
                if dry_run:
                    print(cmd)
                else:
                    subprocess.run(cmd)

        for f in filenames:
            cmd = lnsfv + [confpath + f, homepath + f]
            if dry_run:
                print(cmd)
            else:
                subprocess.run(cmd)


if __name__ == "__main__":
    link_files(dry_run=False)
