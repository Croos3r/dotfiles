return {
  "folke/sidekick.nvim",
  opts = {
    -- Sidekick owns Copilot's Next Edit Suggestions now.
    nes = { enabled = true },
    cli = {
      mux = {
        enabled = false,
      },
      win = {
        layout = "right",
      },
    },
  },
  keys = {
    {
      "<leader>aa",
      function() require("sidekick.cli").toggle() end,
      desc = "Toggle AI CLI",
    },
    {
      "<leader>as",
      function() require("sidekick.cli").select({ filter = { installed = true } }) end,
      desc = "Select AI CLI",
    },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "copilot", focus = true }) end,
      desc = "Toggle Copilot CLI",
    },
    {
      "<leader>ao",
      function() require("sidekick.cli").toggle({ name = "opencode", focus = true }) end,
      desc = "Toggle OpenCode",
    },
    {
      "<leader>af",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send file to AI CLI",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = "x",
      desc = "Send selection to AI CLI",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Select AI prompt",
    },
    {
      "<leader>ad",
      function() require("sidekick.cli").close() end,
      desc = "Detach AI CLI",
    },
  },
}
