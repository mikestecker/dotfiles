#!/usr/bin/env python3
"""Select the dotfiles dynamic profile after iTerm2 loads it."""

import json
from pathlib import Path

import iterm2

PROFILE = Path.home() / ".dotfiles" / "iterm2" / "profile.json"


async def main(connection):
    guid = json.loads(PROFILE.read_text())["Profiles"][0]["Guid"]
    matches = await iterm2.PartialProfile.async_query(connection, guids=[guid])
    if matches:
        await matches[0].async_make_default()


iterm2.run_until_complete(main)
