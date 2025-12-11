---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "lua-language-server",
        "stylua",
        "docker-language-server",
        "hadolint",
        "jq",
        "marksman",
        "prettierd",
        "yaml-language-server",
        "bash-language-server",
        "shellcheck",
        "shfmt",
        "terraform-ls",
        "tflint",
        "tfsec",
        "typescript-language-server",
        "gopls",
        "goimports",
        "python-lsp-server",
        "ruff",
      },
    },
  },
}
