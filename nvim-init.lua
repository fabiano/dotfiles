local let sysname = vim.loop.os_uname().sysname

-- enable backspace
vim.o.backspace = 'indent,eol,start'

-- disable create backup file on save
vim.o.backup = false
vim.o.writebackup = false

-- hide current mode in the command line
vim.o.showmode = false

-- disable swap file creation
vim.o.swapfile = false

-- disable line wrap
vim.o.wrap = false

-- use shift + arrows to start visual mode
vim.o.keymodel = 'startsel'

-- highlight current line
vim.o.cursorline = true

-- show line numbers
vim.o.number = true
vim.o.numberwidth = 5

-- hide filename on tab bar
vim.o.showtabline = 0

-- always show the status line
vim.o.laststatus = 2

-- configure status line
local let modes = {
  ['n']   = 'NORMAL',
  ['no']  = 'NORMAL,OP',
  ['v']   = 'VISUAL',
  ['V']   = 'V-LINE',
  ['\22'] = 'V-BLOCK',
  ['s']   = 'SELECT',
  ['S']   = 'S-LINE',
  ['^S']  = 'S-BLOCK',
  ['i']   = 'INSERT',
  ['R']   = 'REPLACE',
  ['Rv']  = 'V-REPLACE',
  ['c']   = 'COMMAND',
  ['cv']  = 'VIM EX',
  ['ce']  = 'EX',
  ['r']   = 'PROMPT',
  ['rm']  = 'MORE',
  ['r?']  = 'CONFIRM',
  ['!']   = 'SHELL',
  ['t']   = 'TERMINAL',
}

local function statusline()
  return ''
    .. ' '                  -- space
    .. ' '                  -- space
    .. modes[vim.fn.mode()] -- mode
    .. ' '                  -- space
    .. ' '                  -- space
    .. '%F'                 -- file name
    .. '%='                 -- align right
    .. '%l'                 -- current line number
    .. ':'                  -- separator
    .. '%L'                 -- total line number
    .. ' '                  -- space
    .. ' '                  -- space
end

vim.o.statusline = statusline()

vim.api.nvim_create_autocmd("ModeChanged", {
  callback = function()
    vim.opt.statusline = statusline()
  end,
})

-- hide line and column number in the command line
vim.o.ruler = false

-- hide partial commands in the command line
vim.o.showcmd = false

-- prevent echoing the file name in the command line
vim.o.shortmess = 'FW'

-- show diagnostics and code actions icons over the line number
vim.o.signcolumn = 'number'

-- set diagnostics to show as a virtual text after the end of the line
vim.diagnostic.config({
  underline = false,
  update_in_insert = true,
  severity_sort = true,

  virtual_text = {
    spacing = 1,
    prefix = "●",
  },

  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN]  = " ",
      [vim.diagnostic.severity.HINT]  = " ",
      [vim.diagnostic.severity.INFO]  = " ",
    },
  },
})

-- allow to keep the buffer unsaved in the background
vim.o.hidden = true

-- set space as the leader key
vim.g.mapleader = ' '

vim.keymap.set("n", " ", "<Nop>", { silent = true })

-- tabs
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

-- whitespace characters
vim.o.listchars = 'space:·,tab:» ,trail:·'
vim.o.list = false

-- enable auto-complete
vim.o.completeopt = 'menuone,noinsert,noselect,popup'

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.lsp.completion.enable(true, args.data.client_id, 0, { autotrigger = true })
  end,
})

-- enable reading .nvimrc from the current directory
vim.o.exrc = true

-- disable bell sounds
vim.o.belloff = 'all'

-- change splits direction
vim.o.splitbelow = true
vim.o.splitright = true

-- change vertical separator
vim.o.fillchars = 'vert:█'

-- syntax highlighting
vim.o.syntax = 'on'
vim.o.filetype = 'on'

-- show opened filename in the console title
vim.o.title = true
vim.o.titlestring = 'nv: %t'

-- set the border style for all floating windows
vim.o.winborder = 'solid'

-- use clipboard instead of registers
vim.o.clipboard = 'unnamedplus'

-- theme
vim.cmd.colorscheme('habamax')

vim.api.nvim_set_hl(0, "FloatBorder", { link = "Pmenu" })

-- reset kitty padding
if os.getenv('TERM') == 'xterm-kitty' then
  vim.cmd [[
    autocmd VimEnter * execute 'silent! !kitten @ set-spacing padding=0'
    autocmd VimLeave * execute 'silent! !kitten @ set-spacing padding=5'
  ]]
end

-- install mini.deps
local let mini_path = vim.fn.stdpath('data') .. '/site' .. '/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')

  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/nvim-mini/mini.nvim',
    mini_path,
  })

  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- add plugins
local let MiniDeps  = require('mini.deps')

MiniDeps.setup()
MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add('nvim-lua/plenary.nvim')
MiniDeps.add('nvim-mini/mini.bracketed')
MiniDeps.add('nvim-mini/mini.pairs')
MiniDeps.add('nvim-mini/mini.tabline')
MiniDeps.add('nvim-telescope/telescope.nvim')
MiniDeps.add('stevearc/conform.nvim')

-- configure mini.bracketed
local let MiniBracketed = require('mini.bracketed')

MiniBracketed.setup()

-- configure mini.pairs
local let MiniPairs = require('mini.pairs')

MiniPairs.setup()

-- configure mini.tabline
local let MiniTabLine = require('mini.tabline')

MiniTabLine.setup()

-- configure telescope
local let Telescope = require('telescope')

Telescope.setup({
  defaults = {
    sorting_strategy = 'ascending',

    layout_config = {
      horizontal = {
        prompt_position = "top",
        preview_width   = 0.7,
        width           = { padding = 0 },
        height          = { padding = 0 },
      },

      vertical = {
        prompt_position = "top",
        preview_width   = 0.75,
        width           = { padding = 0 },
        height          = { padding = 0 },
      },
    },
  },
})

-- keymaps
local let builtin = require('telescope.builtin')

vim.keymap.set('n', '<Tab>', ':bn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':bp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', builtin.find_files, { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-p>', function() builtin.find_files({ cwd = vim.fn.expand('%:p:h') }) end, { noremap = true, silent = true })
vim.keymap.set('n', '<C-g>', builtin.git_status, { noremap = true, silent = true })
vim.keymap.set('n', 'gd', builtin.lsp_definitions, { noremap = true, silent = true })
vim.keymap.set('n', 'gi', builtin.lsp_implementations, { noremap = true, silent = true })
vim.keymap.set('n', 'gr', builtin.lsp_references, { noremap = true, silent = true })
vim.keymap.set('n', 'K',  function() vim.lsp.buf.hover({ max_width = 80, max_height = 10 }) end, { noremap = true, silent = true })
vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover({ max_width = 80, max_height = 10 }) end, { noremap = true, silent = true })
vim.keymap.set('n', 'g.', vim.lsp.buf.code_action, { noremap = true, silent = true })
vim.keymap.set('n', 'cd', vim.lsp.buf.rename, { noremap = true, silent = true })
vim.keymap.set('n', 'gs', builtin.lsp_document_symbols, { noremap = true, silent = true })
vim.keymap.set('n', 'gS', builtin.lsp_dynamic_workspace_symbols, { noremap = true, silent = true })
vim.keymap.set('n', '<C-t>', builtin.lsp_document_symbols, { noremap = true, silent = true })
vim.keymap.set('n', '<C-S-t>', builtin.lsp_workspace_symbols, { noremap = true, silent = true })
vim.keymap.set('i', 'jj', '<Esc>', { noremap = true, silent = true })
vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { noremap = true, silent = true })
vim.keymap.set('i', '<C-s>', function() vim.lsp.buf.signature_help({ max_width = 80, max_height = 10 }) end, { noremap = true, silent = true })

-- use enter to clear last search highlighting
vim.keymap.set('n', '<CR>', ':noh<CR><CR>', { noremap = true, silent = true })

-- use esc to close the quickfix window
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',

  callback = function(args)
    vim.keymap.set('n', '<Esc>', '<C-w>c', { noremap = true, silent = true })
  end,
})

