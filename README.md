# Conflicted-Computing

<img src="https://github.com/bigfnj/conflicted-computing/blob/master/spy_vs_spy_banner.jpeg" width="624" height="250" />

This project started as a place to store my user bash\_profile so I would always have an accessible way retrieve and leverage my customizations from any location or server that I would grace with my logon presence.

It started out as “gee I would shore like to know where I am right now without typing pwd”. Over the years it has transformed from a simple PS1= “pwd user@host” $ into a giant messy:

PS1="\\n\\\[\\e\[0;95m\\\]\\w\\\[\\e\[1;95m\\\]\\\[\\e\[m\\\] \\n\\$(if \[\[ \\$? == 0 \]\]; then echo \\"\\\[\\e\[1;92m\\\]:)\\"; else echo \\"\\\[\\e\[1;31m\\\]:(\\"; fi)\\\[\\033\[00m\\\] \\\[\\e\[0;36m\\\]\\u\\\[\\e\[4;36m\\\]@\\\[\\e\[0;36m\\\]\\h\\\[\\e\[m\\\] \\\[\\e\[1;94m\\\]\\\\$\\\[\\e\[m\\\] "

Which is actually the following but color coded:

*PWD*

*EXITSTATUS USER@HOST $*


And FINALLY today, into a function that can be read and manipulated by any human. The challenges were getting the prompt to be dynamic and more informative without introducing complexity. A second challenge is figuring out how to run an else/if statement that would execute properly as a function within the PS1 variable… looooong story!

So that being said, it grew, and grew, and grew some more. To the point where my .bash\_profile was over 1200 lines of code (it’s still here as LOADED).

The first steps were to make the profile more modular IE: break the aliases and functions into their own load scripts, introduce a color table to make the functions and scripts more human readable, ensure the existing dependencies for functions were supported properly, and finally to just have some fun and a few kick ass little Easter eggs.

SUCCESS!!!

Admittedly this took me a few years, and without any real concentrated effort on a **FINAL** goal or what I wanted this to all boil down to in the end. Further, I am not a coder or scripter so the research involved on my end took hours and a multitude of trial & error. I also borrowed code from various blogs, forums and websites all over the web which I would like to give credit, but never documented where anything came from as it came in bits & pieces.

Now on to what I have collected here.

The core of the project load here is the bash\_profile.txt

-   Create a file in your home directory called .bash\_profile

-   Remember to :set paste

-   Paste the contents of bash\_profile.txt into the file

-   :wq

This file is the “skeleton” of a modular *system* that will then load the rest of the content you wish to use. You can also plug your own loads into the file following the commented format contained within the file.

\*Keep in mind, they load in the order they appear in the file, so if there is a dependency on something that is loaded later, it may not work. Always remember that load order is king, and you will be fine.

The .bash\_profile currently loads the following in this order:

1.  bashrc

    1.  (duh)

2.  .ascii

    1.  A print of asci art. There is a kickass sample in the GIT that I think looks great in a terminal window
    2.  Paste the contents from ascii.txt into ~/.ps1/.ascii

3.  Fortune

    1.  If fortune is installed, it will give you one! Can be combined with cowsay if you are so inclined

4.  .bash\_colorlist

    1.  Loads a color decode table into linux so that all future “asks” for colorization can be done in a simpler human readable format
    2.  Paste the contents from bash\_colorlist into ~/.ps1/.bash\_colorlist

5.  Userid\_load

    1.  You can create a file here based on your userid, and if your userid equals the filename, it will also load.

    2.  This is useful when multiple users *sudo* into a shared account. This way you can sudo over, and have your customizations load, without forcing your customization package on anyone else in the environment.

6.  .bash\_aliases

    1.  A separate file of system aliases is easier to manage and maintain than including them directly into your profile.
    2.  Paste the contents from bash_aliases.txt into ~/.ps1/.bash\_aliases

7.  .bash\_functions

    1.  A separate file of user defined “functions”. Let’s just keep things tidy and modular, not all systems can handle functions either, so it’s simple to comment all of the functions out at once if they fail, or simply dont include this file.
    2.  Paste the contents from .ps1/.bash\_functions.txt into ~/.ps1/.bash\_functions

8.  .bash\_ps1\_functions & .bash\_ps1\_standard

    1.  Here at the tail end is what initially started this pet project. The all informative, all-inclusive bash prompt.

       .  **Functions**

-   a prompt that relies completely on functions and is enhanced so that different parts of the prompt are color coded depending on what is happening on the system (well get to that later).

       .  **Standard**

-   a prompt that relies on nothing; no colorlist, no functions, etc. This prompt is dynamic to the extent that the exit code smiley changes and the color coding changes if you are root or not root. It’s simple, its straight forward, and has worked properly on every system I have put it on.

Obviously getting complex can lead to strange, bizarre or inexplicable behavior. Remember you can always SSH into your machine with the following command and it will ignore all bash profile loads so you can correct your errors and try again:

*ssh -t HOSTNAME "bash --noprofile --norc"*

Now, let’s understand the prompt itself.
Open the prompt file: .bash_ps1_functions
__
In order moving down, we see the initial makeup of the prompt itself as:

### NEWLINE PWD
### SMILEY USER@HOST $

Newline is simply that, we create a "new line" after the text on the screen to avoid clutter and confusion. We follow that with a pwd command to show our current location in the file system. Here we actually insert another newline so that when we are deep in the file system, it doesnt interupt the prompt, it also keeps the prompt position consistent which is nice.

The prompt start with a smiley (I know right!) it smiles green if your last run action returned a success, if not, its red and frowny!... I'm not going to lie, figuring out how to write this as a function, and later return the result of that function into a command prompt was a fucking nightmare. If your curious the challenge is that the prompt is generated ONCE, when you login. whereas you can write an else statement for the prompt, it doesnt work once you introduce functions into the prompt (such as color coding pieces of it based on what is happening in the system).

Now a space, your currently logged in username... the @ symbol and the hostname of the machine. Finally the prompt ender which is a $ when you are NOT root, and a # when you ARE root.

--Now for colors
In the pwd for current directory on the system
```PWD:
    Green     == more than 10% free disk space
    Orange    == less than 10% free disk space
    ALERT     == less than 5% free disk space
    Red       == current user does not have write privileges
    Cyan      == current filesystem is size zero (like /proc)
```    
For the Smiley we have:
``` SMILEY:
    Green     == last exit code was positive
    Red       == last exit code was negative
```    
For username:
``` USER:
    Cyan      == normal user
    Orange    == SU to user
    Red/White == root
```    
The @ symbol I decided not to color, as it got a little confusing and no longer worked as a clean break in the prompt seperating the user from the host

For host:
``` HOST:
    Cyan      == local session
    Green     == secured remote connection (via ssh)
    Red       == unsecured remote connection
```    
And finally our prompt ender $:
``` $:
    White     == no background or suspended jobs in this shell
    Cyan      == at least one background job in this shell
    Orange    == at least one suspended job in this shell
```
=========================================
The next portion of the prompt file is the set of functions that are used to return a color based on the scripted logic. You can assign these colors/functions to any part of the prompt you like, but this seemed to make the most sense to me.

Towards the end you see the actual prompt construction script, and it finally ends with turning the prompt itself into a system function. Turning it into a system function is necessary in order to have the prompt re-run all of the functions to determine if anything has changed IE: if you move into a restricted directory, the PWD will turn red notifying you that you do not have write permission in that directory, the only way to trigger this check is to turn the prompt into a function that is run everytime the prompt is generated in the terminal.


### Now we construct the prompt.
```
        # PWD (with 'disk space' info):
        PS1="\n\[\$(disk_color)\]\w\[${NC}\] "

        # Exit Command (as a colored smiley)
        PS1=${PS1}"\n$ERRPROMPT\[${NC}\] "

        # User@Host (with connection type info):
        PS1=${PS1}"\[${SU}\]\u\[${NC}\]@\[${CNX}\]\h\[${NC}\] "

        # End Prompt (with 'job' info):
        PS1=${PS1}"\[\$(job_color)\]\\$\[${NC}\] "
```


### Set PROMPT_COMMAND to a function
```
export PROMPT_COMMAND=prompt_ps1
```

==============================================

There are a few samples of other constructed prompts in there but this should get you started!

## TO DO:
1. Put picture examples of prompt in the readme
2. Explain other files in the GIT
3. Document & explain SecureCRT configuration
4. The prompt doesnt always refresh out properly after say, cat on an executable file, reading up I believe the prompt doesnt know its current position in relation to the terminal window. There are a LOT of different suggestions on correcting this, but I have not found one to be consistent across multiple terminal interfaces (PUTTY, SECURECRT, Etc.)


### Alias's Breakdown:

# `_bash_aliases` — File Breakdown

## What It Is

A **bash aliases file** — a collection of shorthand command definitions meant to be sourced from `.bashrc` or `.bash_profile`. Every `alias` here either replaces a default command with a better-behaved version, or creates a new short command that saves typing.

---

## What Each Section Does

### Colorize

- `grep` always runs with line numbers (`-n`) and color highlighting — makes search results immediately scannable.

---

### Generic QoL

| Alias | Command | Purpose |
|---|---|---|
| `c` | `clear` | Clears the screen in one keystroke |
| `..` | `cd ..` | Go up one directory level |
| `sudo` | `sudo ` | Trailing space tells bash to also alias-expand the next word, so `sudo ll` works |
| `wget` | `wget -c` | Always resumes interrupted downloads instead of starting over |
| `tf` | `tail -250f` | Follow log files with a 250-line buffer |
| `mkdir` | `mkdir -pv` | Always creates parent directories silently, so `mkdir a/b/c` just works |
| `du` | `du -ach \| sort -h` | Human-readable disk usage, sorted by size |

---

### The `ls` Family

All color-aware. Built around a consistent long-list base (`ll`).

| Alias | Behavior |
|---|---|
| `ls` | Default listing with color |
| `lx` | Sort by file extension |
| `lk` | Sort by size, biggest last |
| `lt` | Sort by date, newest last |
| `lc` | Sort by change time |
| `lu` | Sort by access time |
| `ll` | Long list, directories first, alphanumeric sort |
| `lm` | `ll` piped through `more` |
| `la` | Show hidden files, newest last |
| `l.` | Hidden files only, no directories |
| `lah` | Hidden files in long format |
| `lr` | Recursive long list |

---

### Added / Extended Commands

| Alias | Command | Purpose |
|---|---|---|
| `ports` | `netstat -tulanp` | All listening/connected TCP+UDP ports |
| `meminfo` | `free -m -l -t` | Memory summary broken out by type |
| `mount` | `mount \| column -t` | Mount output formatted into aligned columns |
| `now` | `date +"%T \| %m-%d-%Y"` | Current time and date: `HH:MM:SS \| MM-DD-YYYY` |
| `psg` | `ps aux \| grep ...` | Filter processes by name — pass argument e.g. `psg nginx` |

---

### Process Memory Monitoring

| Alias | Behavior |
|---|---|
| `psmem` | All processes sorted by memory consumption, highest first |
| `psmem10` | Same, capped to top 10 |

---

### PATH Pretty-Print

| Alias | Behavior |
|---|---|
| `path` | Prints each `$PATH` entry on its own line |
| `libpath` | Same for `$LD_LIBRARY_PATH` |

---

### iptables (Sudo Section)

These all require sudo privileges and `/sbin/iptables` to exist.

| Alias | Behavior |
|---|---|
| `ipt` | Shorthand for `sudo /sbin/iptables` |
| `iptlist` | Verbose numbered listing of all chains |
| `iptlistin` | INPUT chain only |
| `iptlistfw` | FORWARD chain only |
| `iptlistout` | OUTPUT chain only |
| `firewall` | Alias for `iptlist` |

---

## Dependencies / What Needs to Be in Place

This file has **no hard external dependencies** — it will source cleanly on any standard Linux system. A few exceptions:

### Commented-Out Aliases (require manual setup before enabling)

1. `#alias vi='vim'`
   Needs `vim-enhanced` installed:
   ```bash
   # Debian/Ubuntu
   apt install vim
   # RHEL/Fedora
   dnf install vim-enhanced
   ```

2. `#alias cat='ccat'`
   Needs the [`ccat`](https://github.com/jingweno/ccat) binary at `/usr/bin/ccat` with execute permissions:
   ```bash
   chmod +x /usr/bin/ccat
   ```
   `ccat` is a syntax-highlighted drop-in replacement for `cat`.

### `netstat` (used by `ports`)

`netstat` is in the `net-tools` package, which isn't always installed by default on newer distros. If `ports` fails, install it or use the modern equivalent:

```bash
# Install net-tools
apt install net-tools        # Debian/Ubuntu
dnf install net-tools        # RHEL/Fedora

# Or use the modern equivalent directly
ss -tulanp
```

### iptables vs nftables

Most modern distros default to `nftables` rather than `iptables`. If the `ipt*` aliases fail, your system may need:
```bash
apt install iptables     # Debian/Ubuntu
dnf install iptables     # RHEL/Fedora
```

---

## How to Load It

Source from `.bashrc` or `.bash_profile`:

```bash
source ~/.config/bash/_bash_aliases
```

If used alongside companion bash config files, the recommended source order is:

```bash
source ~/.config/bash/_bash_colors          # Color variables — MUST be first
source ~/.config/bash/_bash_ps1_functions   # Prompt — depends on color vars
source ~/.config/bash/_bash_aliases         # Aliases — no dependencies
```




### PROMPT_COMMAND

## How it works

`PROMPT_COMMAND` is a bash variable. Whatever string is in it gets **executed as a command before every prompt is drawn**. The project uses it to run a function that rebuilds `PS1` dynamically — so every prompt reflects current system state.

---

## The execution model

```bash
PROMPT_COMMAND=prompt_ps1
```

Every time you hit Enter (before the next `$` appears), bash calls `prompt_ps1()`. That function:

1. **Captures `$?` first** — this is critical. `$?` holds the exit code of your last command, but it gets clobbered the moment any other command runs. So it must be the very first thing grabbed.
2. Calls `disk_color()` — reads `df` for the current PWD filesystem, checks `-w` write permission
3. Calls `load_color()` — reads `/proc/loadavg`, strips the decimal, compares against thresholds
4. Calls `job_color()` — runs the `jobs` builtin to count background/suspended processes
5. Assembles a new `PS1` string with all those color codes baked in
6. Shell renders the finished `PS1`

---

## What each color function signals

```
disk_color()  → Green   = writable, normal usage
              → BRed    = disk > 90% full
              → ALERT   = disk > 95% full
              → Red     = no write permission in PWD
              → Cyan    = zero-size virtual fs (/proc, /sys)

load_color()  → Green   = load < 100 × NCPU
              → BYellow = load < 200 × NCPU
              → BRed    = load < 400 × NCPU
              → ALERT   = load >= 400 × NCPU

job_color()   → BCyan   = background jobs running
              → BRed    = suspended jobs exist
```

Load thresholds scale with CPU count: `NCPU=$(grep -c 'processor' /proc/cpuinfo)` — so a 4-core machine has `SLOAD=400`, `MLOAD=800`, `XLOAD=1600`.

---

## The exit smiley

The exit code smiley lives directly in the `PS1` string as an inline conditional:

```bash
$(if [[ $? == 0 ]]; then echo "\[\e[1;92m\]:)"; else echo "\[\e[1;31m\]:("; fi)
```

Green `:)` on success, red `:(` on failure. In the function-based prompt, `$?` is captured at the top of `prompt_ps1` so it's available throughout.

---

## Prompt format (assembled output)

```
Line 1: [disk_color] /current/working/dir [reset]
Line 2: [:) or :(]  [user@host in connection+user color]  [$ in job_color]
```

The two-line format keeps the actual command input area clean regardless of how long the path is.

---

## The two implementations

**`.bash_ps1_functions`** — full dynamic version:
- `PROMPT_COMMAND=prompt_ps1` calls the function every prompt
- All three color functions fire on every keypress of Enter
- Disk check hits `df` every prompt (minor I/O cost)

**`.bash_ps1_standard`** — static fallback:
- No `PROMPT_COMMAND` — uses inline `$()` in PS1 directly
- Only the exit smiley is dynamic (evaluated at render time)
- No disk/load/job colors — works on any system with no dependencies

---

## The `SUDO_PS1` export

Both prompt files do:
```bash
export SUDO_PS1=$PS1
```
This passes the configured prompt into sudo sessions so the visual context (user color, root indicator) carries through when you `sudo su` or `sudo -i`.

---

## From the examples

`examples/function_examples.sh` shows a more elaborate `PROMPT_COMMAND` pattern where the function is named `__prompt_command` and also prepends the numeric exit code to the prompt when it's non-zero — so you see `[127] :(` instead of just `:(`. That pattern isn't in the deployed files, just documented as a reference.

`examples/subash_prompt_example.sh` extends `PROMPT_COMMAND` further to also run `git fetch --quiet &` in the background if `FETCH_HEAD` is more than 60 minutes old — so git status is always fresh without blocking the prompt.
