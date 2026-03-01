-- install mini.deps
local mini_path = vim.fn.stdpath('data') .. '/site' .. '/pack/deps/start/mini.nvim'

if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')

  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--branch',
    'stable',
    'https://github.com/nvim-mini/mini.nvim',
    mini_path,
  })

  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- add plugins
local MiniDeps  = require('mini.deps')

MiniDeps.setup()
MiniDeps.add('junegunn/fzf')
MiniDeps.add('junegunn/fzf.vim')
MiniDeps.add('neovim/nvim-lspconfig')
MiniDeps.add('stevearc/conform.nvim')
MiniDeps.add('nvim-mini/mini.pairs')

local MiniPairs = require('mini.pairs')

MiniPairs.setup()

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
local modes = {
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

-- theme
vim.cmd.colorscheme('habamax')

-- buffer keymaps
vim.keymap.set('n', '<Tab>',      ':bn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>',    ':bp<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>bd', ':bd<CR>', { noremap = true, silent = true })

-- window keymaps
vim.keymap.set('n', '<Leader><Leader>', '<C-w>w',           { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>ww',       '<C-w>w',           { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>wc',       '<C-w>c',           { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>wh',       ':<C-u>split<CR>',  { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>wv',       ':<C-u>vsplit<CR>', { noremap = true, silent = true })

-- use enter to clear last search highlighting
vim.keymap.set('n', '<CR>', ':noh<CR><CR>', { noremap = true, silent = true })

-- fzf keymaps
vim.keymap.set('n', '<Leader>p', function()
  local options = vim.call('fzf#vim#with_preview', {
    options = {
      '--prompt', '> ',
      '--layout', 'reverse',
      '--border',
      '--style', 'full',
      '--preview-window', 'right,70%',
      '--border-label', ' ' .. vim.fn.expand('%:p:h') .. ' '
    }
  })

  vim.call('fzf#vim#files', '', options, 1)
end, { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>P', function()
  local options = vim.call('fzf#vim#with_preview', {
    options = {
      '--prompt', '> ',
      '--layout', 'reverse',
      '--border',
      '--style', 'full',
      '--preview-window', 'right,70%',
      '--border-label', ' ' .. vim.fn.expand('%:p:h') .. ' '
    }
  })

  vim.call('fzf#vim#files', vim.fn.expand('%:p:h'), options, 1)
end, { noremap = true, silent = true })

vim.keymap.set('n', '<Leader>gs', function()
  local options = {
    options = {
      '--prompt', '> ',
      '--layout', 'reverse',
      '--border',
      '--style', 'full',
      '--preview-window', 'bottom,75%',
      '--border-label', ' Changes '
    }
  }

  vim.call('fzf#vim#gitfiles', '?', options, 1)
end, { noremap = true, silent = true })

-- lsp keymaps
vim.keymap.set('i', '<C-Space>',  function() vim.lsp.completion.get()       end, { noremap = true, silent = true })
vim.keymap.set('n', 'gd',         function() vim.lsp.buf.type_definition()  end, { noremap = true, silent = true })
vim.keymap.set('n', 'gi',         function() vim.lsp.buf.implementation()   end, { noremap = true, silent = true })
vim.keymap.set('n', 'gr',         function() vim.lsp.buf.references()       end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>gd', function() vim.lsp.buf.type_definition()  end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>gi', function() vim.lsp.buf.implementation()   end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>gr', function() vim.lsp.buf.references()       end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>.',  function() vim.lsp.buf.code_action()      end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>r',  function() vim.lsp.buf.rename()           end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>t',  function() vim.lsp.buf.document_symbol()  end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>T',  function() vim.lsp.buf.workspace_symbol() end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>d',  function() vim.lsp.buf.hover()            end, { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>f',  function() require("conform").format()    end, { noremap = true, silent = true })

-- use esc to close the quickfix window
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',

  callback = function(args)
    vim.keymap.set('n', '<Esc>', '<C-w>c', { noremap = true, silent = true })
  end,
})

-- reset kitty padding
vim.cmd [[
  autocmd VimEnter * execute 'silent! !kitten @ set-spacing padding=0'
  autocmd VimLeave * execute 'silent! !kitten @ set-spacing padding=5'
]]

