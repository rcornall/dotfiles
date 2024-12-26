require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {
        "clangd",
        "rust_analyzer",
        "lua_ls",
        "vimls",
    },
})
local lspconfig = require'lspconfig'

local lsp_status = require('lsp-status')
lsp_status.config({
  -- disable diagnostics
  -- diagnostics = false,
  -- Optionally disable messages
  -- messages = false,
  -- disable current function
  current_function = false,
  show_filename = false,
  indicator_errors = 'X',
  indicator_warnings = 'W',
  status_symbol = '',
  update_interval = 80
})
lsp_status.register_progress()


local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>r', [[<cmd>lua require'telescope.builtin'.lsp_document_symbols{symbol_width=50}<CR>]], opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts)

    vim.keymap.set("v", "gq", vim.lsp.buf.format, { remap = false })
    vim.cmd [[ command! Format execute 'lua vim.lsp.buf.formatting()' ]]
    -- Set autocommands conditional on server_capabilities
    local encoding = client.offset_encoding and client.offset_encoding[0] or "utf-16"
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = bufnr,
            callback = function()
                local params = vim.lsp.util.make_position_params(nil, encoding)
                vim.lsp.buf_request(0, "textDocument/documentHighlight", params)
            end,
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end

    require "lsp_signature".on_attach()
    lsp_status.on_attach(client)
end

local default_capabilities = vim.lsp.protocol.make_client_capabilities()
default_capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- call each lsp setup with the extended capabilities and on_attach, and optional settings.
lspconfig.clangd.setup({
    cmd = { "/home/rcornall/.local/share/nvim/mason/bin/clangd",
            "--background-index",
            -- "--limit-references=1000000",
            -- "--limit-results=1000000",
            -- "--query-driver=/opt/toolchain/bin/aarch64-poky-linux-g++",
            "--header-insertion=never"},
    handlers = lsp_status.extensions.clangd.setup(),
    on_attach = on_attach,
    init_options = { clangdFileStatus = true},
    capabilities = vim.tbl_extend('keep', default_capabilities or {}, lsp_status.capabilities)
})

lspconfig.rust_analyzer.setup({
    -- cmd = {".."},
    --
    cmd = { "/home/rcornall/.local/bin/rust-analyzer"},
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allTargets = false,
            },
            -- procMacro = {
                -- enable = false
            -- },
            check = {
                allTargets = false
            },
        }
    },
    on_attach = on_attach,
    capabilities = vim.tbl_extend('keep', default_capabilities or {}, lsp_status.capabilities)
})

-- lspconfig.pylsp.setup({
    -- on_attach = on_attach,
    -- capabilities = vim.tbl_extend('keep', default_capabilities or {}, lsp_status.capabilities)
-- })

local lua_runtime_path = vim.split(package.path, ';')
table.insert(lua_runtime_path, 'lua/?.lua')
table.insert(lua_runtime_path, 'lua/?/init.lua')
lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = lua_runtime_path,
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file('', true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = on_attach,
    capabilities = vim.tbl_extend('keep', default_capabilities or {}, lsp_status.capabilities)
})
lspconfig.vimls.setup({
    on_attach = on_attach,
    capabilities = vim.tbl_extend('keep', default_capabilities or {}, lsp_status.capabilities)
})

-- luasnip setup
local luasnip = require 'luasnip'
local types = require("luasnip.util.types")
luasnip.config.setup({
    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = {{"●", "GruvboxOrange"}}
            }
        },
        [types.insertNode] = {
            active = {
                virt_text = {{"●", "GruvboxBlue"}}
            }
        }
    },
})
-- require("luasnip.loaders.from_vscode").load()
require("luasnip.loaders.from_vscode").load ({
  paths = "/home/rcornall/.my-snippets",
})

-- cmp setup
local cmp = require("cmp")

local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

cmp.setup({
    snippet = {
        expand = function(args)
            -- For `vsnip` user.
            -- vim.fn["vsnip#anonymous"](args.body)

            -- For `luasnip` user.
            require("luasnip").lsp_expand(args.body)

            -- For `ultisnips` user.
            -- vim.fn["UltiSnips#Anon"](args.body)
        end,
    },
    mapping = {
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ['<C-e>'] = cmp.mapping.close(),
        -- Accept currently selected item. If none selected, `select` first item.
        -- Set `select` to `false` to only confirm explicitly selected items.
        ["<CR>"] = cmp.mapping.confirm { select = false, behavior = cmp.ConfirmBehavior.Replace },
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif check_backspace() then
                fallback()
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, {
            "i",
            "s",
        }),
    },
    fields = { "kind", "abbr", "menu" },

    format = function(entry, vim_item)
        -- Kind icons
        vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
        -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
        vim_item.menu = ({
            nvim_lsp = "[LSP]",
            nvim_lua = "[NVIM_LUA]",
            luasnip = "[Snippet]",
            buffer = "[Buffer]",
            path = "[Path]",
        })[entry.source.name]
        return vim_item
    end,
    sources = {
        { name = "nvim_lsp" },
        { name = "nvim_lua" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
    },
})

-- telescope
local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
require('telescope').setup{
    defaults = {
        scroll_strategy = "limit",
        find_command = { "rg", "--files", "--no-ignore-parent" },
        vimgrep_arguments = {
            "rg",
            "--no-ignore-parent", -- don't respect .gitignore when in a subdir.
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case"
        },
        mappings = {
            i = {
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
                ["?"] = action_layout.toggle_preview,

                ["<C-w>"] = function()
                    vim.api.nvim_input "<c-s-w>"
                end,
                ["<esc>"] = actions.close,
            },
            n = {
                -- <esc><esc> is mapped to nohlsearch.. doesn't work, rely on insert mode esc instead.
                ["<esc>"] = actions.close,
            },
        },
    },
}

-- treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "cpp", "lua", "rust", "python" },
    auto_install = true,
    highlight = {
        enable = true
    },
    incremental_selection = {
        enable = true
    },
    textobjects = {
        enable = true
    },
    additional_vim_regex_highlighting = false,
}

-- sync with system clipboard on focus
vim.api.nvim_create_autocmd({ "FocusGained" }, {
    pattern = { "*" },
    command = [[call setreg("@", getreg("+"))]],
})
vim.api.nvim_create_autocmd({ "FocusLost" }, {
    pattern = { "*" },
    command = [[call setreg("+", getreg("@"))]], 
})
vim.api.nvim_create_autocmd({ "VimSuspend" }, {
    pattern = { "*" },
    command = [[call setreg("+", getreg("@"))]], 
})
vim.api.nvim_create_autocmd({ "VimResume" }, {
    pattern = { "*" },
    command = [[call setreg("@", getreg("+"))]],
})
