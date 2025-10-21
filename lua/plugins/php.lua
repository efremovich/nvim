return {
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = function()
      local dap = require("dap")

      -- Способ 1: Используем $MASON переменную
      local mason_share_path = vim.fn.expand("$MASON/share/php-debug-adapter")
      local mason_packages_path = vim.fn.expand("$MASON/packages/php-debug-adapter")

      -- Проверяем доступные пути
      local possible_paths = {
        mason_share_path .. "/extension/out/phpDebug.js",
        mason_packages_path .. "/extension/out/phpDebug.js",
        mason_share_path .. "/out/phpDebug.js",
        mason_packages_path .. "/out/phpDebug.js",
      }

      local php_debug_path = nil
      for _, path in ipairs(possible_paths) do
        if vim.fn.filereadable(path) == 1 then
          php_debug_path = path
          break
        end
      end

      -- Если файл не найден, пробуем через exepath (если адаптер доступен в PATH)
      if not php_debug_path then
        local exe_path = vim.fn.exepath("php-debug-adapter")
        if exe_path ~= "" then
          -- Если это Node.js скрипт, используем его напрямую
          php_debug_path = exe_path
        end
      end

      if php_debug_path then
        dap.adapters.php = {
          type = "executable",
          command = "node",
          args = { php_debug_path },
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
      else
        vim.notify("php-debug-adapter not found. Please install it via Mason and check the path.", vim.log.levels.WARN)
      end
    end,
  },
}
