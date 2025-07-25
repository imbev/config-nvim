local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then --- @diagnostic disable-line
  print('Installing lazy.nvim...')
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=v11.17.1',
    lazypath,
  })
  print('Done.')
end
vim.opt.rtp:prepend(lazypath)


require('lazy').setup({
  {'ray-x/starry.nvim', commit = '972158d6f9a630fad1954f42b921983ab4de8ab3'},
  {'neovim/nvim-lspconfig', tag='v1.7.0'},
  {'hrsh7th/cmp-nvim-lsp', commit='99290b3ec1322070bcfb9e846450a46f6efa50f0'},
  {'hrsh7th/nvim-cmp', tag='v0.0.2'},
  {'williamboman/mason.nvim', tag='v1.11.0'},
  {'williamboman/mason-lspconfig.nvim', tag='v1.32.0'},
  {'akinsho/bufferline.nvim', tag='v4.9.1'},
  {'lewis6991/gitsigns.nvim', tag='v1.0.1'},
})

require('starry').setup({})
vim.opt.termguicolors = true
vim.opt.colorcolumn = '80'
vim.cmd.colorscheme('darksolar')

require('bufferline').setup{
  options = {
    buffer_close_icon = 'x',
    close_icon = 'x',
    left_trunc_market = '...',
    right_trunc_marker = '...',
    get_element_icon = function(_)
      return ''
    end,
    diagnostics = 'nvim_lsp'
  }
}
require('gitsigns').setup{}


vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.opt.signcolumn = 'yes'
vim.opt.number = true


local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)


vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    vim.keymap.set('n', '<Space>e', '<cmd>lua vim.diagnostic.setqflist()<cr>', opts)
    vim.keymap.set('n', '<Space>f', '<cmd>lua vim.lsp.buf.format()<cr>', opts)
  end,
})


require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  },
})


local cmp = require('cmp')
cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item({behavior = 'select'}),
    ['<C-n>'] = cmp.mapping.select_next_item({behavior = 'select'}),
    ['<CR>'] = cmp.mapping.confirm({select = false}),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
})

vim.keymap.set('t', '<ESC>', '<C-\\><C-n>')
