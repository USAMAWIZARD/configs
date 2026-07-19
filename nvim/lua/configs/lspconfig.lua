require("nvchad.configs.lspconfig").defaults()
require("auto-save").setup {}

vim.g.instant_username = "usama"
require("live-share").setup({
  port_internal = 8888,
  max_attempts = 40, -- 10 seconds
  service_url = "/tmp/service.url",
  service = "localhost.run"
})
local lspconfig = vim.lsp.config

local servers = { "html", "cssls", "lua_ls", "clangd", "gopls", "pyright" }
local nvlsp = require "nvchad.configs.lspconfig"

local function on_attach(client, bufnr)
  local opts = { buffer = bufnr, remap = false }
  vim.keymap.set("n", "gd", function()
    vim.lsp.buf.definition()
  end, opts)
  vim.keymap.set("n", "gi", function()
    vim.lsp.buf.implementation()
  end, opts)
  vim.keymap.set("n", "<leader>vws", function()
    vim.lsp.buf.workspace_symbol()
  end, opts)
  vim.keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float()
  end, opts)
  vim.keymap.set("n", "gl", function()
    vim.diagnostic.goto_next()
  end, opts)
  vim.keymap.set("n", "gh", function()
    vim.diagnostic.goto_prev()
  end, opts)
  vim.keymap.set("n", "<leader>ca", function()
    vim.lsp.buf.code_action()
  end, opts)
  vim.keymap.set("n", "<leader>rr", function()
    vim.lsp.buf.references()
  end, opts)
  vim.keymap.set("n", "<leader>rn", function()
    vim.lsp.buf.rename()
  end, opts)
  vim.keymap.set("i", "<C-h>", function()
    vim.lsp.buf.signature_help()
  end, opts)
end

for _, lsp in ipairs(servers) do
  local opts = {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }

  if lsp == "gopls" then
    opts.settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
        },
      },
    }
  end

  lspconfig(lsp, opts)
  vim.lsp.enable(lsp)
end


local function get_jdtls_config()
  local root_dir = require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
  local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
  -- per-project data dir under nvim cache (no need to hardcode paths)
  local workspace_dir = vim.fn.stdpath "cache" .. "/jdtls-workspace/" .. project_name

  local bundles = {
    vim.fn.glob(
      "/home/usama/.m2/repository/com/microsoft/java/com.microsoft.java.debug.plugin/0.53.1/com.microsoft.java.debug.plugin-*.jar",
      true
    ),
  }
  vim.list_extend(bundles, vim.split(vim.fn.glob("/home/usama/tem/vscode-java-test/server/*.jar", true), "\n"))

  return {
    cmd = {
      "/usr/lib/jvm/java-21-openjdk/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      "-Dlog.protocol=true",
      "-Dlog.level=ALL",
      "-Xmx1g",
      "--add-modules=ALL-SYSTEM",
      "--add-opens",
      "java.base/java.util=ALL-UNNAMED",
      "--add-opens",
      "java.base/java.lang=ALL-UNNAMED",
      "-jar",
      "/home/usama/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.7.100.v20251111-0406.jar",
      "-configuration",
      "/home/usama/.local/share/nvim/mason/packages/jdtls/config_linux/",
      "-data",
      workspace_dir,
    },
    root_dir = root_dir,
    settings = {},
    init_options = {
      bundles = bundles,
    },
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      require("jdtls").setup_dap { hotcodereplace = "auto", config_overrides = {} }
    end,
  }
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require("jdtls").start_or_attach(get_jdtls_config())
  end,
})

vim.opt.spelllang = 'en_us'
vim.opt.spell = true
