Arma 3 Dedicated startup infrastructure
=======================================

This is intended for a small group of people hosting dedicated servers from
their PC workstations and potentially exchanging saved state, so that anyone
can host and the saved state (CBA settings, persistent world saves, etc.)
is transferred over.

How to use
----------
1. Place the `.bat` file and `dedicated-config` into Arma 3 install folder
1. Optionally configure mods and parameters inside the `.bat` file
1. Start the `.bat` file, which starts up Arma 3 dedicated server
1. When shutting down, close the Arma 3 window, **not** the console window
1. When Arma 3 exits, the `.bat` script does a backup of the saved state
   into `dedicated-config`
1. Now you can zip / move `dedicated-config` to somebody else

When receiving `dedicated-config`, delete `dedicated-local-tmp` first,
if it exists.

The script works by having two folders:
- `dedicated-config` (which is meant to be easily editable/portable)
- `dedicated-local-tmp` (which is messy and local to your PC)

**If and only if** `dedicated-local-tmp` does not exist, the script reads
`dedicated-config` and produces `dedicated-local-tmp` to be used by Arma 3
exe. In other words, `dedicated-config` **is never read again** if
`dedicated-local-tmp` exists, only written to.

So if a friend sends you `dedicated-config`, you need to delete
`dedicated-local-tmp` or you'll be playing on your old save (and overwrite
`dedicated-config` when the Arma 3 exe exits). This is for safety reasons
(so you don't lose data when your PC crashes while the server is running).

For more details / config options, read the first few lines of the `.bat`.
