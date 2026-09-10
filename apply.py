#!/usr/bin/env python3
"""Repair moved-checkout links and apply dotfiles, preserving conflicts."""

import argparse
from datetime import datetime
import os
from pathlib import Path
import shutil
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", type=Path, default=Path.home())
    args = parser.parse_args()
    target = args.target.expanduser().resolve(strict=True)
    stow_dir = Path(__file__).resolve().parent / "stow"
    if not shutil.which("stow"):
        parser.error("stow is required; install it with brew install stow")
    backup_dir = None
    backup_count = 0

    def backup(path):
        nonlocal backup_dir, backup_count
        if backup_dir is None:
            backup_dir = Path(tempfile.mkdtemp(
                prefix=".mysetup-backup-" + datetime.now().strftime("%Y%m%d-%H%M%S-"),
                dir=target,
            ))
        # Separate entries prevent a saved parent symlink from redirecting a
        # later child backup into the original checkout.
        backup_count += 1
        dest = backup_dir / str(backup_count) / path.relative_to(target)
        dest.parent.mkdir(parents=True, exist_ok=True)
        if path.is_symlink():
            # Relative links would break when moved into the backup directory.
            link = os.readlink(path)
            dest.symlink_to(os.path.abspath(path.parent / link))
            path.unlink()
        else:
            path.rename(dest)
        print(f"Backed up {path} to {dest}", flush=True)

    def prepare(source, dest):
        if source.is_dir():
            if dest.is_symlink():
                # Unfold old directory links, keeping app state outside the repo.
                # Copy before unlinking so a failed copy leaves the original intact.
                with tempfile.TemporaryDirectory(prefix=".mysetup-unfold-", dir=target) as tmp:
                    copied = Path(tmp) / "contents"
                    if dest.is_dir():
                        shutil.copytree(dest, copied, symlinks=True)
                    else:
                        copied.mkdir()
                    backup(dest)
                    copied.rename(dest)
            elif dest.exists() and not dest.is_dir():
                backup(dest)
            dest.mkdir(parents=True, exist_ok=True)
            for child in sorted(source.iterdir()):
                prepare(child, dest / child.name)
        elif dest.is_symlink() and dest.resolve() == source.resolve():
            return
        elif dest.exists() or dest.is_symlink():
            backup(dest)

    packages = sorted(p for p in stow_dir.iterdir() if p.is_dir())
    for package in packages:
        for source in sorted(package.iterdir()):
            prepare(source, target / source.name)
    command = ["stow", f"--dir={stow_dir}", f"--target={target}",
               "--no-folding", "--restow", *[p.name for p in packages]]
    subprocess.run([*command, "--simulate"], check=True)
    subprocess.run(command, check=True)
    print(f"Dotfiles linked from {stow_dir.parent}")


if __name__ == "__main__":
    main()
