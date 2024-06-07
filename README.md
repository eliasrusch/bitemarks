# Bitemarks.nvim

Bitemarks is a simple plugin that adds indicators for every marks created.

## Installation

### Lazy

```lua
{
    "eliasrusch/bitemarks",
    config = function()
        require("bitemarks").setup()
    end
}
```

## Planned in the future

- maintain markers through sessions
- add configuration options for marker color and position
- add "marker mode" to jump between markers without pressing '
- fix issues with marker overlaying over text at end of line, move marker down on line lenght change
