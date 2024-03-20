return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "bashls", "clangd", "pyright", "zls", "tsserver" },
        auto_install = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local nvlsp = require("lspconfig")
      require("lspconfig").lua_ls.setup({
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if not vim.loop.fs_stat(path .. "/.luarc.json") and not vim.loop.fs_stat(path .. "/.luarc.jsonc") then
            client.config.settings = vim.tbl_deep_extend("force", client.config.settings, {
              Lua = {
                runtime = {
                  -- Tell the language server which version of Lua you're using
                  -- (most likely LuaJIT in the case of Neovim)
                  version = "LuaJIT",
                },
                -- Make the server aware of Neovim runtime files
                workspace = {
                  checkThirdParty = false,
                  library = {
                    vim.env.VIMRUNTIME,
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                  },
                  -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                  -- library = vim.api.nvim_get_runtime_file("", true)
                },
              },
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end
          return true
        end,
      })

      -- clangd
      nvlsp.clangd.setup({})
      --pyright
      nvlsp.pyright.setup({})
      --bashls
      nvlsp.bashls.setup({})
      --zls : zig
      nvlsp.zls.setup({})
      --tsserver
      nvlsp.tsserver.setup({})
    end,
  },
}
