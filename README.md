# omarchy-digital-clock

A minimal digital clock desktop widget for [Omarchy](https://omarchy.org/), built with [eww](https://github.com/elkovar/eww).

- Live seconds update (1s poll)
- Automatically adapts to Omarchy's light/dark theme (Flexoki palette)
- Sits on the desktop behind all windows (stacking: bottom)
- Monospace font: JetBrains Mono / Fira Code / Cascadia Code

## Screenshot

```
┌──────────────────────────┐
│       14:32:07           │
│    Monday, April 27      │
└──────────────────────────┘
```

## Requirements

- [Omarchy](https://omarchy.org/) with Hyprland
- [eww](https://github.com/elkowar/eww) (`yay -S eww`)
- A monospace font: JetBrains Mono, Fira Code, or Cascadia Code

## Installation

```bash
git clone https://github.com/mehtad/omarchy-digital-clock ~/Development/omarchy-digital-clock
cd ~/Development/omarchy-digital-clock
bash install.sh
```

The installer merges the clock definitions into your existing `~/.config/eww/eww.yuck` and `~/.config/eww/eww.scss` — it won't overwrite anything else.

### Manual installation

If you prefer, copy and paste from `eww/clock.yuck` into your `eww.yuck` and `eww/clock.scss` into your `eww.scss`, then run:

```bash
eww reload
eww open clock
```

## Usage

```bash
eww open clock      # show
eww close clock     # hide
eww reload          # reload after config changes
```

## Customization

Edit `~/.config/eww/eww.yuck` to change the position:

```yuck
(defwindow clock
  :geometry (geometry
    :x "16px"
    :y "16px"
    :width "380px"
    :anchor "top right")   ; top left / top right / bottom left / bottom right
  ...)
```

Edit `~/.config/eww/eww.scss` to change font or size:

```scss
.clock-time {
  font-size: 44px;       ; adjust to taste
  letter-spacing: 2px;
}
```

## Coexisting with omarchy-ticktick-widget

If you already use [omarchy-ticktick-widget](https://github.com/mehtad/omarchy-ticktick-widget), the theme-aware color polls (`root_bg_style`, `fg_style`, `muted_style`) are already defined. The `clock.yuck` file uses separate poll names (`clock_root_bg_style`, `clock_fg_style`, `clock_muted_style`) to avoid conflicts — no changes needed.
