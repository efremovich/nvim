return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")
      local path = require("mason-registry").get_package("php-debug-adapter"):get_install_path()
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { path .. "/extension/out/phpDebug.js" },
      }
      dap.configurations.php = {
        {
          name = "Listen for Xdebug",
          type = "php",
          request = "launch",
          port = 9000,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
        {
          name = "Launch currently open script",
          type = "php",
          request = "launch",
          program = "${file}",
          cwd = "${fileDirname}",
          port = 9000,
        },
        {
          name = "Launch Built-in web server",
          type = "php",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
          port = 9000,
          runtimeArgs = {
            "-dxdebug.start_with_request=yes",
            "-S",
            "localhost:0",
          },
          env = {
            XDEBUG_MODE = "debug,develop",
            XDEBUG_CONFIG = "client_port=${port}",
          },
        },
      }
    end,
  },
}
