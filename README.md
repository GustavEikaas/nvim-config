Personalized nvim config for TS Code editing

## Prerequisites

- Choco
- Zig
- Neovim

## DAP
C# requires netcoredbg to be in path 

## Spotify
Install spotify-tui
```bash 
choco install spotify-tui
```

## DBUI

### Prerequisites
1. sqlcmd

### Example

1. :DBUI<CR>
2. A 
3. sqlserver://root:yourpassword@localhost/dbname?TrustServerCertificate=true


## Roslyn

1. Install C# devkit from vscode extensions
2. open `~/.vscode/extensions/ms-dotnettools.csharp-.../.roslyn/`
3. Copy all contents into `nvim-data/roslyn`
