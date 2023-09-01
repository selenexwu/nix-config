-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
return {
  -- first key is the mode
  n = {
    -- second key is the lefthand side of the map
    -- mappings seen under group name "Buffer"
    ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
    ["<leader>bD"] = {
      function()
        require("astronvim.utils.status").heirline.buffer_picker(function(bufnr) require("astronvim.utils.buffer").close(bufnr) end)
      end,
      desc = "Pick to close",
    },
    -- tables with the `name` key will be registered with which-key if it's installed
    -- this is useful for naming menus
    ["<leader>b"] = { name = "Buffers" },

    ["<A-Up>"] = { ":m .-2<CR>==" },
    ["<A-k>"] = { ":m .-2<CR>==" },
    ["<A-Down>"] = { ":m .+1<CR>==" },
    ["<A-j>"] = { ":m .+1<CR>==" }, 
  },
  t = {
    -- setting a mapping to false will disable it
    -- ["<esc>"] = false,
  },
  i = {
        ["<A-Up>"] = { "<Esc>:m .-2<CR>==gi" },
        ["<A-k>"] = { "<Esc>:m .-2<CR>==gi" },
        ["<A-Down>"] = { "<Esc>:m .+1<CR>==gi" },
        ["<A-j>"] = { "<Esc>:m .+1<CR>==gi" },
    },
}
