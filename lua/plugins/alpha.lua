local Ascii = {}

Ascii.neovim = {
  [[███    ██ ████████ ████████ ██    ██ ██ ███    ███]],
  [[████   ██ ██       ██    ██ ██    ██ ██ ████  ████]],
  [[██ ██  ██ ████████ ██    ██ ██    ██ ██ ██ ████ ██]],
  [[██  ██ ██ ██       ██    ██  ██  ██  ██ ██  ██  ██]],
  [[██   ████ ████████ ████████   ████   ██ ██      ██]],
}

local function button(sc, txt, keybind)
  local sc_ = sc:gsub("%s", ""):gsub("SPC", "<leader>")
  local opts = {
    position = "center",
    text = txt,
    shortcut = sc,
    cursor = 6,
    width = 19,
    align_shortcut = "right",
    hl_shortcut = "Number",
    hl = "Function",
  }
  if keybind then
    opts.keymap = { "n", sc_, keybind, { noremap = true, silent = true } }
  end
  return {
    type = "button",
    val = txt,
    on_press = function()
      local key = vim.api.nvim_replace_termcodes(sc_, true, false, true)
      vim.api.nvim_feedkeys(key, "normal", false)
    end,
    opts = opts,
  }
end

return {
  'goolord/alpha-nvim',
  event = "VimEnter",
  cond = function()
    return not vim.g.vscode
  end,
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local present, alpha = pcall(require, "alpha")
    if not present then
      return
    end
    local header = {
      type = "text",
      val = Ascii.neovim,
      opts = {
        position = "center",
        hl = "DashboardHeader",
      },
    }
    -- local greeting = getGreeting()
    local buttons = {
      type = "group",
      val = {
        button("f", "󰱼  Search", ":Telescope find_files<CR>"),
        button("e", "  New", ":ene<CR>"),
        -- button("b", " Jump to bookmarks", ":Telescope marks<CR>"),
        button("c", "  Config", ":e $HOME/.config/nvim/init.lua | :cd %:p:h | :silent !pwd<CR>"),
        button("q", "  Quit", ":qa<CR>"),
      },
      opts = {
        position = "center",
        spacing = 1,
      },
    }
    local section = {
      header = header,
      buttons = buttons,
      footer = {
        type = "text",
        val = {},
        opts = {
          position = "center",
          hl = "Comment",
        },
      }
    }
    local opts = {
      layout = {
        { type = "padding", val = function() return math.floor(vim.o.lines * 0.25) end },
        section.header,
        { type = "padding", val = 1 },
        section.message,
        { type = "padding", val = 2 },
        section.buttons,
        { type = "padding", val = 1 },
        section.footer,
      },
      opts = {
      },
    }
    alpha.setup(opts)
    local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
    autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        -- local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        local ms = stats.startuptime
        local version = " v" ..
            vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
        local plugins = "⚡plugins " .. stats.loaded .. "/" .. stats.count .. " in " .. ms .. "ms"
        local footer = version .. "\t" .. plugins .. "\n"
        section.footer.val = footer
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
    -- Disable the statusline, tabline and cmdline while the alpha dashboard is open
    autocmd('User', {
      pattern = 'AlphaReady',
      desc = 'disable status, tabline and cmdline for alpha',
      callback = function()
        vim.go.laststatus = 0
        vim.opt.showtabline = 0
        vim.opt.cmdheight = 0
      end,
    })
    autocmd('BufUnload', {
      buffer = 0,
      desc = 'enable status, tabline and cmdline after alpha',
      callback = function()
        vim.go.laststatus = 2
        vim.opt.showtabline = 2
        vim.opt.cmdheight = 1
      end,
    })
  end
}
