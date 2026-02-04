require("nvchad.configs.lspconfig").defaults()
require("auto-save").setup {}

vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')

vim.g.instant_username = "usama"
require("live-share").setup({
  port_internal = 8888,
  max_attempts = 40, -- 10 seconds
  service_url = "/tmp/service.url",
  service = "localhost.run"
})
local lspconfig = vim.lsp.config

lspconfig('', {
  on_attach = on_attach,
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  -- root_dir = lspconfig.util.root_pattern("go.work", "go.mod", ".git"),
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})

local servers = { "html", "cssls", "lua_ls", "clangd", "gopls","python" }
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
  lspconfig(lsp, {
    on_attach = on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end


local workspace_dir = "/home/usama/learn/AntMedia/workspace/"
local jdtlsConfig = {

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
    -- 💀
    -- See `data directory configuration` section in the README
    "-data",
    workspace_dir,
  },
  settings = {
    -- settings configuration
  },
  init_options = {
    bundles = {
    },
  },
}
local bundles = {
  vim.fn.glob(
    "/home/usama/.m2/repository/com/microsoft/java/com.microsoft.java.debug.plugin/0.53.1/com.microsoft.java.debug.plugin-*.jar",
    true),
};

vim.list_extend(bundles, vim.split(vim.fn.glob("/home/usama/tem/vscode-java-test/server/*.jar", true), "\n"))
jdtlsConfig.init_options = {
  bundles = bundles,
}

jdtlsConfig.on_attach = function(client, bufnr)
  on_attach(client, bufnr)
  require('jdtls').setup_dap({ hotcodereplace = 'auto', config_overrides = {} })
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    require('jdtls').start_or_attach(jdtlsConfig)
  end
})

vim.opt.spelllang = 'en_us'
vim.opt.spell = true
