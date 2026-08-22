hl.config({
  input = {
    kb_layout = "us",
    kb_options = "ctrl:nocaps,shift:both_capslock_cancel",

    sensitivity = 0.2,

    touchpad = {
      natural_scroll = true,
      scroll_factor = 0.2,

      clickfinger_behavior = true,
      tap_and_drag = false,
      drag_3fg = 1,
    },
  },
})

hl.gesture({ fingers = 4, direction = "horizontal", scale = 1.5, action = "workspace" })
