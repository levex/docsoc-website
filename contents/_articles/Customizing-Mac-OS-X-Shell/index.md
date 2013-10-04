---
title: Customizing Mac OS X Shell
author: Matthew Sojourner Newton
date: 2012-08-22 17:11
template: article.jade
---

![Shell Screen 1](screen1.png)

I've been customizing my Mac OS X shell a bit today. The cyan above is for the current directory and the purple shows the current git branch, which is why it appears when I change directory to a git repository.

##FIRST: oh-my-zsh
I used [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) to start, but I didn't like any of the included themes.

##NEXT: thoughtbot/dotfiles
The thoughtbot guys have put together a nice [zsh dotfiles setup](https://github.com/thoughtbot/dotfiles). They include a handy little script that symlinks from the dotfiles directory to your .* files themselves, making it easy to link up your dotfiles to a github repository for sharing and copying to additional computers.

##CUSTOMIZING
My contribution to all this? I extracted the code the thoughtbot guys used to generate their prompt and made a zsh-theme file out of it:

`oh-my-zsh/themes/thoughtbot.zsh-theme:`

    # adds the current branch name in green
    git_prompt_info() {
      ref=$(git symbolic-ref HEAD 2> /dev/null)
      if [[ -n $ref ]]; then
        echo "[%{$fg_bold[magenta]%}${ref#refs/heads/}%{$reset_color%}]"
      fi
    }

    # expand functions in the prompt
    setopt prompt_subst

    # prompt
    export PROMPT='$(git_prompt_info)[${SSH_CONNECTION+"%{$fg_bold[green]%}%n@%m:"}%{$fg_bold[blue]%}%1~%{$reset_color%}] '

    local return_status="%{$fg[red]%}%(?..✘)%{$reset_color%}"
    RPROMPT='${return_status}%{$reset_color%}'

I added an idea from [Steve Losh](http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/) and from [Aaron Malone](http://blog.munge.net/2011/10/fun-with-zsh-themes/). By the way, I really like those themes as well. I recommend Aaron's version just because it's a little more robust.

What theme am I using in the screenshot? Tomorrow Night Eighties from [Chris Kempson's Tomorrow Night Eighties](https://github.com/chriskempson/Tomorrow-Theme) for [iTerm2](http://www.iterm2.com). I'm also using the Tomorrow Theme to highlight the code above.

##My Files
You can check out [my dotfiles](https://github.com/mnewt/dotfiles) and [customized oh-my-zsh](https://github.com/mnewt/oh-my-zsh) on my [github](https://github.com/mnewt).

Feedback and suggestions welcome.
