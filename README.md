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
# NEWLINE PWD
# SMILEY USER@HOST $

Newline is simply that, we create a "new line" after the text on the screen to avoid clutter and confusion. We follow that with a pwd command to show our current location in the file system. Here we actually insert another newline so that when we are deep in the file system, it doesnt interupt the prompt, it also keeps the prompt position consistent which is nice.

The prompt start with a smiley (I know right!) it smiles green if your last run action returned a success, if not, its red and frowny!... I'm not going to lie, figuring out how to write this as a function, and later return the result of that function into a command prompt was a fucking nightmare. If your curious the challenge is that the prompt is generated ONCE, when you login. whereas you can write an else statement for the prompt, it doesnt work once you introduce functions into the prompt (such as color coding pieces of it based on what is happening in the system).

Now a space, your currently logged in username... the @ symbol and the hostname of the machine. Finally the prompt ender which is a $ when you are NOT root, and a # when you ARE root.

--Now for colors
