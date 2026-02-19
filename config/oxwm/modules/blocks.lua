return {
    oxwm.bar.block.shell({
       format = "{}",
       command = "$HOME/.dotfiles/config/oxwm/scripts/network.sh",
       interval = 30,
       color = colors.red,
       underline = true,
    }),
    oxwm.bar.block.static({
        text = " │  ",
        interval = 999999999,
        color = colors.lavender,
        underline = false,
    }),
    oxwm.bar.block.battery({
        format = "Bat: {}%",
        charging = "⚡ Bat: {}%",
        discharging = "- Bat: {}%",
        full = "✓ Bat: {}%",
        interval = 30,
        color = colors.green,
        underline = true,
    }),
    oxwm.bar.block.static({
        text = " │  ",
        interval = 999999999,
        color = colors.lavender,
        underline = false,
    }),
    oxwm.bar.block.datetime({
        format = "{}",
        date_format = "%-H:%M",
        interval = 1,
        color = colors.cyan,
        underline = true,
    }),
};
