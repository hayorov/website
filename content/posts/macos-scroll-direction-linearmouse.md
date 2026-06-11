+++
title = "Two Devices, One Scroll Setting: Fixing a Decade-Old macOS Annoyance"
date = "2026-06-11"
description = "How LinearMouse ended my twice-a-day natural-scrolling toggle ritual between a desk mouse and the MacBook trackpad."
tags = ["macos", "productivity", "tools"]
+++

> 💻 MacBook Air, docked at the desk with a mouse — trackpad-only everywhere else
> 🐭 One global "natural scrolling" toggle, two devices that want opposite things
> ✅ LinearMouse: per-device scrolling, set once, forget forever

For years I had this dumb little ritual. Dock the laptop in the morning, grab the mouse, scroll — page flies the wrong way. Open System Settings, flip Natural Scrolling off. Pack up in the evening, open the laptop on the couch, and now the trackpad scrolls backwards. Flip it back on. Twice a day, every day.

I'd love to tell you I fixed this years ago like a reasonable person. I did not. I just kept flipping that checkbox.

## Why this is even a thing

The toggle lives in **System Settings → Trackpad → Natural Scrolling**, but despite sitting under "Trackpad", it controls the mouse too. One checkbox, both devices.

And the two devices genuinely want opposite directions. A trackpad should scroll like a phone screen — content follows your fingers, anything else feels broken. A mouse wheel should scroll like a mouse wheel: wheel down, page down, the way it has worked since the 90s. There is no position of that checkbox that's right for both. Apple has shipped it unchanged for over a decade.

## LinearMouse

The fix turned out to be a small open-source app called [LinearMouse](https://linearmouse.app). It does one clever thing: it applies pointer and scroll settings per device. The trackpad and the mouse stop sharing a fate.

```shell
brew install --cask linearmouse
```

The whole setup took me about a minute:

1. Launch it, grant the Accessibility permission it asks for
2. Leave macOS Natural Scrolling **on** — that keeps the trackpad correct
3. Pick the mouse in LinearMouse's device dropdown
4. Turn on **Scrolling → Reverse scrolling → Vertical** for it
5. Enable **Start at login**

That's the entire fix. Trackpad scrolls like a phone, mouse scrolls like a mouse, and docking is no longer a settings event.

While you're in there, do yourself one more favor: **Pointer → Disable pointer acceleration** for the mouse. macOS acceleration is weirdly aggressive, and turning it off made precise cursor work noticeably calmer. Honestly a close second for best feature in the app.

## What about Scroll Reverser and Mos

I tried the alternatives before settling. [Scroll Reverser](https://pilotmoon.com/scrollreverser/) is the classic tool for exactly this problem and still works fine, but it does only that one thing and development has mostly stalled. [Mos](https://mos.caldis.me) is built around smooth scrolling — some people swear by it, to me it feels floaty, like scrolling through syrup. LinearMouse covers the scroll direction, kills the acceleration, and stays out of the way. Easy call.

## A year-ish later

I genuinely don't think about scrolling anymore, which is the whole point. The best tools are the ones you forget you installed. This one took a `brew install` and one checkbox — I'm only annoyed it took me this long.
