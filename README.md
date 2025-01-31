# scrollfix.nvim

[scrollfix.vim](https://github.com/vim-scripts/scrollfix) re-implemented with minor modifications.

Brief introduction of [scrollfix.vim](https://github.com/vim-scripts/scrollfix): a better `scrolloff=999` that

  1. Allows you to choose the percentage of window height to fix your cursor line which `so=999` only let you fix it at the 50% level.
  2. Takes care of the `EOF` as well. Make extra spaces below it.

Why fix cursor position? So you can save the energy from moving your eyes up and down over the monitor. And leave some more space under `EOF` to make it less suffocating, compared with editing at the bottom of the screen.

Note: this plugin may not work well with smooth scrolling plugins.

## Installation

### Lazy.nvim

```lua
-- with default option values
{ "trkwyk/scrollfix.nvim" }

-- with custom option values
{
  "trkwyk/scrollfix.nvim",
  opts = {
    scrollfix = 60, -- percentage of the window height to lock the cursor, default to 50
    -- set scrolloff to 50 and fixeof to false is essentially scrolloff=999
    fixeof = false, -- fix cursor still and leave spaces under when near EOF, default to true
    scrollinfo = true, -- show info when scrollfix is applied, default to false
    -- for LazyVim users: if you want to disable this plugin for LazyVim dashboard, use this
    skip_filetypes = { "snacks_dashboard" }, -- disable scrollfix for specified file types, default to {}
  }
}
```

And other package managers of your choice.

## Credits

* [scrollfix.vim](https://github.com/vim-scripts/scrollfix)
* [stay-centered.nvim](https://github.com/arnamak/stay-centered.nvim): I used to use scrollfix.vim. Recently I migrated to LazyVim I decided to replace old vim modules with lua ones. Tried stay-centered.nvim but it jerks when opening help files then `j`. Hence I create this repo. Stole the `skip_filetypes` feature from it.
