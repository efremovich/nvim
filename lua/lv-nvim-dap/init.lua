local dap =  require'dap'

require('dap').configurations.go = {
    {
      type = 'go';
      name = 'Debug';
      request = 'launch';
      showLog = false;
      program = "${file}";
      dlvToolPath = os.getenv('HOME') .. "/Dev/go/bin/dlv";  -- Adjust to where delve is installed
    },
}

require('dap').adapters.go = {
    type = 'executable';
    command = 'node';
    args = {os.getenv('HOME') .. '/.vscode-oss/extensions/golang.go-0.25/dist/debugAdapter.js'};
}

vim.g.dap_virtual_text = true
