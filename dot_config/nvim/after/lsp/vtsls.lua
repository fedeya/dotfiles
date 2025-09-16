local jsts_settings = {
  updateImportsOnFileMove = { enabled = "always" },
  suggest = { completeFunctionCalls = true },
  inlayHints = {
    enumMemberValues = { enabled = true },
    functionLikeReturnTypes = { enabled = true },
    parameterNames = { enabled = "literals" },
    parameterTypes = { enabled = true },
    propertyDeclarationTypes = { enabled = true },
    variableTypes = { enabled = false },
  },
  tsserver = {
    maxTsServerMemory = 8192,
  }
}


return {
  settings = {
    complete_function_calls = true,
    vtsls = {
      enableMoveToFileCodeAction = false,
      autoUseWorkspaceTsdk = true,
      experimental = {
        maxInlayHintLength = 30,
        completion = {
          enableServerSideFuzzyMatch = true,
        },
      },
    },
    typescript = jsts_settings,
    javascript = jsts_settings,
  },
}
