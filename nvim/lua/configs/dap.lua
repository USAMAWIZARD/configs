local dap = require "dap"
local ui = require "dapui"

require("dapui").setup()
require("dap-go").setup()
require("nvim-dap-virtual-text").setup { enabled = true }


function attach_to_debug()
  local dap = require('dap')
  dap.configurations.java = {
    {
      type = 'java',
      request = 'attach',
      name = 'attach to process',
      hostname = '127.0.0.1',
      port = '8787',
    }
  }
  dap.continue()
end

vim.keymap.set("n", "<leader>ad", ':lua attach_to_debug()<CR>')


local elixir_ls_debugger = vim.fn.exepath "elixir-ls-debugger"
if elixir_ls_debugger ~= "" then
  dap.adapters.mix_task = {
    type = "executable",
    command = elixir_ls_debugger,
  }

  dap.configurations.elixir = {
    {
      type = "mix_task",
      name = "phoenix server",
      task = "phx.server",
      request = "launch",
      projectDir = "${workspaceFolder}",
      exitAfterTaskReturns = false,
      debugAutoInterpretAllModules = false,
    },
  }
end
function get_test_runner(test_name, debug)
  if debug then
    return 'mvn test -Dmaven.surefire.debug -Dtest="' .. test_name .. '"'
  end
  return 'mvn test -Dtest="' .. test_name .. '"'
end

function run_java_test_method(debug)
  local utils = require '../utils'
  local method_name = utils.get_current_full_method_name("\\#")
  vim.cmd('term ' .. get_test_runner(method_name, debug))
end

function run_java_test_class(debug)
  local utils = require '../utils'
  local class_name = utils.get_current_full_class_name()
  vim.cmd('term ' .. get_test_runner(class_name, debug))
end

vim.keymap.set("n", "<space>k", dap.toggle_breakpoint)
vim.keymap.set("n", "<space>gb", dap.run_to_cursor)

vim.keymap.set("n", "<leader>tm", function() run_java_test_method() end)
vim.keymap.set("n", "<leader>TM", function() run_java_test_method(true) end)
vim.keymap.set("n", "<leader>tc", function() run_java_test_class() end)
vim.keymap.set("n", "<leader>TC", function() run_java_test_class(true) end)

-- Eval var under cursor
vim.keymap.set("n", "<space>?", function()
  require("dapui").eval(nil, { enter = true })
end)

vim.keymap.set("n", "<F1>", dap.continue)
vim.keymap.set("n", "<F2>", dap.step_into)
vim.keymap.set("n", "<F3>", dap.step_over)
vim.keymap.set("n", "<F4>", dap.step_out)
vim.keymap.set("n", "<F5>", dap.step_back)
vim.keymap.set("n", "<F13>", dap.restart)

dap.listeners.before.attach.dapui_config = function()
  ui.open()
end
dap.listeners.before.launch.dapui_config = function()
  ui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  ui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  ui.close()
end
