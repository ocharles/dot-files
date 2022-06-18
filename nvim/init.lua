-- Set the leader key before any plugins are set up
vim.g.mapleader = "<Space>"

require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'neovim/nvim-lspconfig'

  use 'folke/tokyonight.nvim'
  use {
    "catppuccin/nvim",
    as = "catppuccin"
  }

  use 'folke/trouble.nvim'
  use 'folke/todo-comments.nvim'

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use 'arkav/lualine-lsp-progress' 

  use 'nvim-treesitter/nvim-treesitter'
  use 'nvim-treesitter/playground'

  use 'kyazdani42/nvim-tree.lua'

  use 'tpope/vim-unimpaired'
  use 'tpope/vim-surround'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-sensible'
  use 'tpope/vim-commentary'

  use 'osohq/polar.vim'

  use 'lewis6991/gitsigns.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
  use 'nvim-telescope/telescope-ui-select.nvim'

  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-cmdline'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-path'
  use 'hrsh7th/nvim-cmp'
  use 'saadparwaiz1/cmp_luasnip'

  use 'L3MON4D3/LuaSnip'

  use 'junegunn/vim-easy-align'
end)

-- Vim options
vim.opt.signcolumn = 'yes'
vim.opt.number = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.clipboard = "unnamedplus"
vim.opt.completeopt = "menuone,noinsert,noselect"

-- tokyonight
vim.g.tokyonight_style = "tokyonight"
vim.g.tokyonight_hide_inactive_statusline = true

-- catppuccin
local catppuccin = require("catppuccin")
catppuccin.setup({
  integrations = {
    lsp_trouble = true
  }
})

-- Leader key bindings
local opts = { noremap=true, silent=true }
vim.api.nvim_set_keymap('n', '<space>ct', '<cmd>TroubleToggle<CR>',                   opts)
vim.api.nvim_set_keymap('n', '<space>e',  '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d',        '<cmd>lua vim.diagnostic.goto_prev()<CR>',  opts)
vim.api.nvim_set_keymap('n', ']d',        '<cmd>lua vim.diagnostic.goto_next()<CR>',  opts)
vim.api.nvim_set_keymap('n', '<space>q',  '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>ff', '<cmd>Telescope find_files<CR>',            opts)
vim.api.nvim_set_keymap('n', '<space>fs', '<cmd>write<cr>',                           opts)
vim.api.nvim_set_keymap('n', '<space>bb', '<cmd>Telescope buffers<CR>',               opts)
vim.api.nvim_set_keymap('n', '<space>sp', '<cmd>Telescope live_grep<CR>',             opts)

-- LSP leader key bindings
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',        '<cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',        '<cmd>lua vim.lsp.buf.definition()<CR>',                                 opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K',         '<cmd>lua vim.lsp.buf.hover()<CR>',                                      opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f',  '<cmd>lua vim.lsp.buf.formatting()<CR>',                                 opts)
end

local util = require('lspconfig').util
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').hls.setup {
  cmd = { "haskell-language-server", "--lsp" },
  on_attach = on_attach,
  flags = { debounce_text_changes = 150 },
  root_dir = util.root_pattern("cabal.project") ,
  capabilities = capabalities
}

-- LSP signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- Slighly nicer inline errors
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = { spacing = 4, prefix = "●" },
  severity_sort = true,
})

-- lualine
require('lualine').setup {
  options = { 
    theme = 'tokyonight',
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch', 
      'diff', 
      {
        'diagnostics',
        symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
      }
    },
    lualine_c = {'filename'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  }, 
}

-- Enable treesitter syntax highlighting
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true
  }
}

-- nvim-tree sidebar file browser
require('nvim-tree').setup {}

-- Trouble for navigating workspace diagnostics
require('trouble').setup {}

-- Highlight TODO/FIXME etc
require('todo-comments').setup {}

-- Git changes as signs
require('gitsigns').setup()

-- nvim-cmp completion
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end
  },
  window = {
  },
  mapping = cmp.mapping.preset.insert({
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' }
  })
}
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Telescope
require('telescope').setup {
  extensions = {
    ["ui-select"] = {
      require("telescope.themes").get_dropdown {
      }
    }
  }
}

require("telescope").load_extension("ui-select")

vim.cmd[[colorscheme catppuccin]]
