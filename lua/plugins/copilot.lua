return {
  "github/copilot.vim",
  lazy = false
  event = "InsertEnter",
  cond = function()
    return not vim.g.vscode
  end,
  filetypes = {
    markdown = true,
    help = true,
  },
}
