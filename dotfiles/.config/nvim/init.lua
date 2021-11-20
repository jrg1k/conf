-- install packer
local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    vim.cmd "packadd packer.nvim"
end

require("packer").startup(function()
    -- plugin manager
    use "wbthomason/packer.nvim"

    -- vcs
    use "tpope/vim-fugitive"
    use "tpope/vim-rhubarb"

    -- handy tools
    use "tpope/vim-commentary"
    use "psf/black"
    use "ludovicchabant/vim-gutentags"
    use "lukas-reineke/indent-blankline.nvim"
    use { "nvim-telescope/telescope.nvim", requires = { "nvim-lua/plenary.nvim" } }
    use { "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } }

    -- eyecandy
    use "morhetz/gruvbox"
    use "itchyny/lightline.vim"

    use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
    use "nvim-treesitter/nvim-treesitter-textobjects"

    -- native lsp
    use "neovim/nvim-lspconfig"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/cmp-vsnip"
    use "hrsh7th/vim-vsnip"
end)

-- python black
vim.g.black_linelength = 88

-- set leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
vim.g.mapleader = " "
vim.g.maplocalleader = " "

--Map blankline
vim.g.indent_blankline_char = "┊"
vim.g.indent_blankline_filetype_exclude = { "help", "packer" }
vim.g.indent_blankline_buftype_exclude = { "terminal", "nofile" }
vim.g.indent_blankline_char_highlight = "LineNr"
vim.g.indent_blankline_show_trailing_blankline_indent = false

-- Gitsigns
require("gitsigns").setup {
    signs = {
        add = { hl = "GitGutterAdd", text = "+" },
        change = { hl = "GitGutterChange", text = "~" },
        delete = { hl = "GitGutterDelete", text = "_" },
        topdelete = { hl = "GitGutterDelete", text = "‾" },
        changedelete = { hl = "GitGutterChange", text = "~" },
    },
}

vim.o.inccommand = "nosplit"
vim.wo.number = true
vim.o.hidden = true
vim.o.mouse = "a"
vim.o.tabstop = 8
vim.o.textwidth = 0
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.smarttab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.breakindent = true
vim.wo.linebreak = true
vim.opt.clipboard = { "unnamedplus" }
vim.o.ff = "unix"
vim.wo.signcolumn = "yes"
vim.o.colorcolumn = "89"
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.undofile = true
vim.o.updatetime = 250
vim.o.completeopt = "menu,menuone,noselect"

-- search
vim.o.hlsearch = false
vim.o.ignorecase = true
vim.o.smartcase = true

-- theme
vim.o.background = "dark"
vim.o.termguicolors = true
vim.g.gruvbox_italic = 1
vim.cmd [[colorscheme gruvbox]]
vim.g.lightline = {
    colorscheme = "gruvbox",
    active = {
        left = {
            { "mode", "paste" },
            { "gitbranch", "readonly", "filename", "modified" },
        },
    },
    component_function = { gitbranch = "fugitive#head" },
}

-- Telescope
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-u>"] = false,
                ["<C-d>"] = false,
            },
        },
    },
}

vim.api.nvim_set_keymap(
    "n",
    "<leader><space>",
    [[<cmd>lua require('telescope.builtin').buffers()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>sf",
    [[<cmd>lua require('telescope.builtin').find_files({previewer = false})<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>sb",
    [[<cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>sh",
    [[<cmd>lua require('telescope.builtin').help_tags()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>st",
    [[<cmd>lua require('telescope.builtin').tags()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>sd",
    [[<cmd>lua require('telescope.builtin').grep_string()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>sp",
    [[<cmd>lua require('telescope.builtin').live_grep()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>so",
    [[<cmd>lua require('telescope.builtin').tags{ only_current_buffer = true }<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "<leader>?",
    [[<cmd>lua require('telescope.builtin').oldfiles()<CR>]],
    { noremap = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "k",
    "v:count == 0 ? 'gk' : 'k'",
    { noremap = true, expr = true, silent = true }
)
vim.api.nvim_set_keymap(
    "n",
    "j",
    "v:count == 0 ? 'gj' : 'j'",
    { noremap = true, expr = true, silent = true }
)

require("nvim-treesitter.configs").setup {
    ensure_installed = "maintained",
    highlight = { enable = true },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true,
            keymaps = {
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = "@class.outer",
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
        },
    },
}

-- LSP settings
local nvim_lsp = require "lspconfig"
local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gD",
        "<cmd>lua vim.lsp.buf.declaration()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gd",
        "<cmd>lua vim.lsp.buf.definition()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gh",
        "<cmd>ClangdSwitchSourceHeader<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gd",
        "<cmd>lua vim.lsp.buf.definition()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "K",
        "<cmd>lua vim.lsp.buf.hover()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gi",
        "<cmd>lua vim.lsp.buf.implementation()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<C-k>",
        "<cmd>lua vim.lsp.buf.signature_help()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>wa",
        "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>wr",
        "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>wl",
        "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>D",
        "<cmd>lua vim.lsp.buf.type_definition()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>rn",
        "<cmd>lua vim.lsp.buf.rename()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "gr",
        "<cmd>lua vim.lsp.buf.references()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>ca",
        "<cmd>lua vim.lsp.buf.code_action()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>e",
        "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "[d",
        "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "]d",
        "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>q",
        "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>",
        opts
    )
    vim.api.nvim_buf_set_keymap(
        bufnr,
        "n",
        "<leader>so",
        [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]],
        opts
    )
    if vim.api.nvim_buf_get_option(bufnr, "filetype") == "python" then
        vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>Black<CR>", opts)
    else
        vim.api.nvim_buf_set_keymap(
            bufnr,
            "n",
            "<leader>f",
            "<cmd>lua vim.lsp.buf.formatting()<CR>",
            opts
        )
    end
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

nvim_lsp.texlab.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        texlab = { build = { onSave = true } },
        latexindent = { modifyLineBreaks = true },
    },
}

local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.sumneko_lua.setup {
    cmd = { "/usr/bin/lua-language-server" },
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path,
            },
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}

-- Enable the following language servers
local servers = { "clangd", "rust_analyzer", "pyright" }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        on_attach = on_attach,
        capabilities = capabilities,
    }
end

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
                :sub(col, col)
                :match "%s"
            == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes(key, true, true, true),
        mode,
        true
    )
end

local cmp = require "cmp"
cmp.setup {
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Insert,
        },
        ["<C-p>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Insert,
        },
        ["<Down>"] = cmp.mapping.select_next_item {
            behavior = cmp.SelectBehavior.Select,
        },
        ["<Up>"] = cmp.mapping.select_prev_item {
            behavior = cmp.SelectBehavior.Select,
        },
        ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "vsnip" },
        { name = "buffer" },
        { name = "path" },
        { name = "cmdline" },
    },
}

cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

cmp.setup.cmdline(
    ":",
    { sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) }
)
