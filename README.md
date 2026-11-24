# Miriarch team builds

Builds of [Miriarch](https://miriarch.com) for the team trying it before public releases: the
newest `main`, built after every change that passes its checks. Installed once, Miriarch updates
itself. When an update has downloaded, the tray offers **Restart to update**, and quitting
installs it too.

These builds are for **Windows (x64)** and **Macs with Apple Silicon**. They aren't signed by
Microsoft or Apple yet, so each system asks once, at install.

## macOS (Apple Silicon)

In Terminal:

```sh
curl -fsSL https://raw.githubusercontent.com/hezzium-dev/miriarch-team-releases/main/install-mac.sh | bash
```

It downloads the newest build, puts `Miriarch.app` in Applications and opens it. Run it again any
time to reinstall.

If you'd rather use the `.dmg` from [the newest release](../../releases/latest): drag Miriarch to
Applications, open it once, then go to System Settings → Privacy & Security and choose
**Open Anyway**.

## Windows

Download `Miriarch-Setup-<version>.exe` from [the newest release](../../releases/latest) and run
it. If SmartScreen says "Windows protected your PC", choose **More info** → **Run anyway**.

## After installing

Sign in with GitHub or Google, then join your team's workspace with the invitation code you were
sent (**Join a team workspace**). Tick **Run coding agents on this computer** there, so the
coding sessions you start run on your computer with your own agent logins (Claude Code, Codex…).

<!-- Source: ops/release/team/ in Miriarch's repository. -->
