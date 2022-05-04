-- init.lua

-- global options start with 'vim.o'
-- local to window start with 'vim.wo'
-- lobal to buffer start with 'vim.bo'

require('packer').startup(function(use)
   use 'wbthomason/packer.nvim'                            -- Packer can manage itself

   use 'nvim-treesitter/nvim-treesitter'                   -- Programming languages parser

   use 'neovim/nvim-lspconfig'                             -- Language Server Protocol configuration
   use 'williamboman/nvim-lsp-installer'                   -- Install LSP with a single command

   use 'hrsh7th/nvim-cmp'                                  -- Lua completion
   use 'hrsh7th/cmp-vsnip'
   use 'hrsh7th/cmp-path'
   use 'hrsh7th/cmp-buffer'

   use 'flazz/vim-colorschemes'                            -- Many colorschemes

   use {
      'nvim-lualine/lualine.nvim',                         -- Status line
      requires = {'kyazdani42/nvim-web-devicons', opt = true}
   }
   use 'nvim-lua/plenary.nvim'                             -- Lua functions (needed for telescope)
   use 'nvim-telescope/telescope.nvim'                     -- Fuzzy finder file previewer
   use 'jremmen/vim-ripgrep'                               -- Fast fuzzy finder

   use {
      'kyazdani42/nvim-tree.lua',                          -- File treeview
      requires = 'kyazdani42/nvim-web-devicons',           -- Icons for the treeview
      config = function() require 'nvim-tree'.setup {} end
   }

   use 'rust-lang/rust.vim'                                -- Rust formatter etc
end)


-- Treesitter configuration
require 'nvim-treesitter.configs'.setup {
   ensure_installed = {"c", "lua", "rust"},
   sync_install = false,
   ignore_install = { "javascript" },
   highlight = { -- enable highlighting
   enable = true,
   -- disable = { "c" },
   additional_vim_regex_highlighting = false,
   },
}

-- Lsp installer configuration
local lsp_installer = require 'nvim-lsp-installer'
lsp_installer.on_server_ready(function(server)
   local opts = {}
   server:setup(opts)
end)

local opts = {noremap = true}
local map = vim.api.nvim_set_keymap
map('n', 'gd', ':lua vim.lsp.buf.definition()<cr>', opts)
map('n', 'gD', ':lua vim.lsp.buf.declaration()<cr>', opts)
map('n', 'gi', ':lua vim.lsp.buf.implementation()<cr>', opts)
map('n', 'gw', ':lua vim.lsp.buf.document_symbol()<cr>', opts)
map('n', 'gw', ':lua vim.lsp.buf.workspace_symbol()<cr>', opts)
map('n', 'gr', ':lua vim.lsp.buf.references()<cr>', opts)
map('n', 'gt', ':lua vim.lsp.buf.type_definition()<cr>', opts)
map('n', 'K', ':lua vim.lsp.buf.hover()<cr>', opts)
map('n', '<c-k>', ':lua vim.lsp.buf.signature_help()<cr>', opts)
map('n', ',af', ':lua vim.lsp.buf.code_action()<cr>', opts)
map('n', '<leader>rn', ':lua vim.lsp.buf.rename()<cr>', opts)


-- Lua completion

local cmp = require'cmp'
cmp.setup({
   -- Enable LSP snippets
   snippet = {
      expand = function(args)
         vim.fn["vsnip#anonymous"](args.body)
      end,
   },
   mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      -- Add tab support
      ['<S-Tab>'] = cmp.mapping.select_prev_item(),
      ['<Tab>'] = cmp.mapping.select_next_item(),

      ['<leader>1'] = cmp.mapping.scroll_docs(-4),
      ['<leader>2'] = cmp.mapping.scroll_docs(4),

      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm({
         behavior = cmp.ConfirmBehavior.Insert,
         select = true,
      })
   },

   -- Installed sources
   sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'path' },
      { name = 'buffer' },
   },
})


-- Lualine configuration
require('lualine').setup()

-- Nvim tree configuration
require'nvim-tree'.setup {
   auto_reload_on_write = true,
   disable_netrw        = true,
   hijack_netrw         = true,
   open_on_setup        = false,
   ignore_ft_on_setup   = {},
   update_to_buf_dir    = {
      enable = true,
      auto_open = true,
   },
   auto_close          = false,
   open_on_tab         = false,
   hijack_cursor       = false,
   update_cwd          = false,
   diagnostics         = {
      enable = false,
      icons = {
         hint    = "",
         info    = "",
         warning = "",
         error   = "",
      }
   },
   update_focused_file = {
      enable      = false,
      update_cwd  = false,
      ignore_list = {}
   },
   system_open = {
      cmd  = nil,
      args = {}
   },
   view = {
      width = 35,
      height = 30,
      side = 'left',
      --auto_resize = false,
      mappings = {
         custom_only = false,
         list = {}
      }
   }
}


local set = vim.opt
set .autoindent = true
-- set .backspace = 'indent,start,eol'
set .backup = false
-- set .backupcopy = 'no'
set .belloff = 'all'
set .clipboard = 'unnamed'

set .fillchars = {
   diff  = '∙',          -- BULLET OPERATOR (U+2219, UTF-8: E2 88 99)
   eob   = ' ',          -- NO-BREAK SPACE (U+00A0, UTF-8: C2 A0) to suppress ~ at EndOfBuffer
   fold  = '·',          -- MIDDLE DOT (U+00B7, UTF-8: C2 B7)
   vert  = '┃',          -- BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
}
set .list = true         -- show whitespace
set .listchars = {
   nbsp     = '⦸',       -- CIRCLED REVERSE SOLIDUS (U+29B8, UTF-8: E2 A6 B8)
   extends  = '»',       -- RIGHT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00BB, UTF-8: C2 BB)
   precedes = '«',       -- LEFT-POINTING DOUBLE ANGLE QUOTATION MARK (U+00AB, UTF-8: C2 AB)
   tab      = '▷⋯',      -- WHITE RIGHT-POINTING TRIANGLE (U+25B7, UTF-8: E2 96 B7) + MIDLINE HORIZONTAL ELLIPSIS (U+22EF, UTF-8: E2 8B AF)
   trail    = '•',       -- BULLET (U+2022, UTF-8: E2 80 A2)
   space    = '·',       -- BULLET (U+2022, UTF-8: E2 80 A2)
   eol      = '⏎',       --
}

-- set .completeopt='menuone, noinsert, noselect' -- unfortunately this does not work
set .completeopt = 'menuone'
set .completeopt = set .completeopt + 'noinsert'
set .completeopt = set .completeopt + 'noselect'

set .cursorline = true
set .expandtab = true
set .shortmess = vim.opt.shortmess + 'A' -- ignore annoying swapfile messages
set .shortmess = vim.opt.shortmess + 'I' -- no splash screen
set .shortmess = vim.opt.shortmess + 'O' -- file-read message overwrites previous
set .shortmess = vim.opt.shortmess + 'T' -- truncate non-file messages in middle
set .shortmess = vim.opt.shortmess + 'W' -- don't echo "[w]"/"[written]" when writing
set .shortmess = vim.opt.shortmess + 'a' -- use abbreviations in messages eg. `[RO]` instead of `[readonly]`
set .shortmess = vim.opt.shortmess + 'c' -- completion messages
set .shortmess = vim.opt.shortmess + 'o' -- overwrite file-written messages
set .shortmess = vim.opt.shortmess + 't' -- truncate file messages at start
set .showbreak = '↳ '                    -- DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
set .wrapscan = true
set .writebackup = false
set .switchbuf = 'useopen'
set .splitright = true
set .textwidth = 80
set .scrolloff = 5
set .showmode = true
set .virtualedit = 'all'
set .hidden = true
set .list = true
set .incsearch = true
set .autoread = true
set .foldenable = false
set .colorcolumn = '80'
set .tabline = ''
set .signcolumn = 'yes'
set .ignorecase = true
set .smartcase = true


-- tab settings
set .tabstop = 3
set .shiftwidth = 3
set .softtabstop = 3

set .smartindent = true
set .smartcase = true
set .guifont='Hack NF:h11'

set .laststatus = 3
set .lazyredraw = true
set .number = true
set .swapfile = false

-- local opts = {noremap = true, silent = true}
local opts = {noremap = true}
local map = vim.api.nvim_set_keymap

map('n', ',n', ':nohls<CR>', opts)
map('n', ',t', ':NvimTreeToggle<CR>', opts)
map('n', ',r', ':NvimTreeRefresh<CR>', opts)

map('n', ',w', ':set invwrap<CR>', opts)
map('n', ',u', 'u ddkP', opts)                 -- bubble up
map('n', ',d', 'u ddjP', opts)                 -- bubble down

map('n', ',h', ':%!xxd<CR>', opts)             -- show content in hexadecimal
map('n', ',H', ':%!xxd -r<CR>', opts)          -- back to ascii again

-- map('n', ',n', ':cn<CR>', opts)             -- go to next error. conflict
-- with nohls

map('n', ',el', ':e ~/AppData/Local/nvim/init.lua<CR>', opts)
map('n', ',so', ':luafile ~/AppData/Local/nvim/init.lua<CR>', opts)

map('v', ',p', 'vertical resize +5<CR>', opts)
map('v', ',m', 'vertical resize -5<CR>', opts)

map('n', '<space><space>', ':bnext<CR>', opts)
map('n', 'dl', '"_dd', opts)

map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)

map('n', '<C-p>', ':Telescope find_files<CR>', opts)
map('n', '<C-f>', ':Rg ', opts)

map('n', '<s-F8>', ':cprev<CR>', opts)
map('n', '<F8>', ':cnext<CR>', opts)

-- Insert and visual mode short keys
map('i', 'jk', '<Esc><space>', opts)
map('i', 'JK', '<Esc><space>', opts)
map('v', 'jk', '<Esc><space>', opts)
map('v', 'JK', '<Esc><space>', opts)


function toggle_background()
   if vim.o.background == 'dark' then
      vim.o.background = 'light'
   else
      vim.o.background = 'dark'
   end
end

map('n', '<F10>', ':lua toggle_background()<CR>', opts)
map('n', '<F11>', ':colorscheme gruvbox<CR>', opts)
map('n', '<F12>', ':colorscheme papercolor<CR>', opts)

vim.cmd('filetype indent plugin on')
vim.cmd('syntax on')
vim.cmd('colorscheme gruvbox')
--  rust
vim.cmd('let g:rustfmt_autosave = 1')
vim.cmd('let g:rustfmt_emit_files = 1')
vim.cmd('let g:rustfmt_fail_silently = 0')
-- vim.cmd('let g:cargo_shell_command_runner = !')





