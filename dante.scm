(use-modules (home)
             (home ssh)
             (home profile)
             (home utils)
             (home bash)
             (home zsh)
             (giiks)
             (giiks emacs-xyz)
             (oop goops)
             (ice-9 format)
             (guix store)
             (guix packages)
             (guix derivations)
             (guix git-download)
             (guix gexp)
             (gnu packages guile)
             (gnu packages xdisorg)
             (gnu packages web-browsers)
             (gnu packages wm)
             (gnu packages package-management)
             (gnu packages fonts)
             (gnu packages autotools)
             (gnu packages gettext)
             (gnu packages perl)
             (gnu packages gnupg)
	     (gnu packages lisp)
             (gnu packages emacs-xyz)
             (gnu packages emacs)
             (gnu packages dvtm)
             (gnu packages abduco)
             (gnu packages shells)
             (gnu packages terminals)
             (gnu packages bittorrent)
             (gnu packages video)
             (gnu packages ncurses)
             (gnu packages fontutils)
             (gnu packages version-control)
             (gnu packages rust-apps))

;(define base-home-configuration (@@ (home) base-home-configuration))

(define (newline-strings strings)
  (string-join strings "\n" 'prefix))

(define (shell-set-env env-value-pairs)
  (define (export-env env-value-pair)
    (format #f "export ~a=~a"
	    (car env-value-pair) (car (cdr env-value-pair))))
  (newline-strings (map export-env env-value-pairs)))

(define coleremak-drv
  (origin->derivation
   (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/maisiliym/coleremak")
           (commit "ffe10ed51234728b5f29f574a7768d7f427487f2")))
     (sha256
      (base32 "0wnjl269y01hnd41r78h6h564j99236n27izmprs2c07f9pv2g08")))))

(define coleremak
  (make Deriveicyn #:inyr coleremak-drv))

(define zsh-coleremak
  (newline-strings
   (list
    (string-append ". " (->path coleremak) "/coleremak.zsh") )))

(define shell-env 
  (shell-set-env 
   (quote 
    (("PATH" "~/.config/guix/current/bin:$PATH")
     ("GUILE_LOAD_PATH" "~/.config/guix/current/share/guile/site/3.0:$GUILE_LOAD_PATH")
     ("GUILE_LOAD_COMPILED_PATH" "~/.config/guix/current/lib/guile/3.0/site-ccache:$GUILE_LOAD_COMPILED_PATH")))))

(define zsh-env 
  (shell-set-env 
   (quote
    (("HISTFILE" "~/.local/share/zsh/history")
     ("HISTSIZE" 10000)
     ("SAVEHIST" 1000)))))

(define interactive-zsh-env 
  (shell-set-env 
   (quote
    (("SSH_AUTH_SOCK" "$(gpgconf --list-dirs agent-ssh-socket)")
     ("EDITOR" "emacs")
     ("FZF_DEFAULT_OPTS" "\"--bind=ctrl-o:up,ctrl-e:up,ctrl-n:down,ctrl-k:down,ctrl-i:clear-screen,ctrl-s:delete-char/eof,ctrl-f:end-of-line,alt-t:forward-word,alt-s:kill-word,ctrl-u:toggle+down,ctrl-l:unix-line-discard,ctrl-j:yank --color=bg:#f9f5d7,bg+:#ebdbb2,fg:#665c54,fg+:#3c3836,header:#076678,hl:#076678,hl+:#076678,info:#b57614,marker:#427b58,pointer:#427b58,prompt:#b57614,spinner:#427b58\"")
     ("FZF_DEFAULT_COMMAND" "\"fd -tf\"")))))

(define interactive-zsh
  (newline-strings
   (list
    "bindkey -v"
    "autoload -U compinit && compinit"
    "autoload -Uz url-quote-magic"
    "zle -N self-insert url-quote-magic"
    "autoload -Uz bracketed-paste-magic"
    "zle -N bracketed-paste bracketed-paste-magic"
    "fpath=(~/.home-profile/share/zsh/site-functions $fpath)"
    ". ~/.home-profile/src/github.com/junegunn/fzf/shell/completion.zsh"
    ". ~/.home-profile/src/github.com/junegunn/fzf/shell/key-bindings.zsh"
    "bindkey '^T' fzf-history-widget"
    "bindkey '^P' fzf-cd-widget"
    "bindkey '^F' fzf-file-widget"
    "bindkey '^N' fzf-completion")))

(define gitconfig-file
  (make-ini-file "git-config"
		 '(("commit"
		    (("gpgSign" "true")))
		   ("init"
		    (("defaultBranch" "mein"))) 
		   ("user"
		    (("email" "@li:maisiliym.uniks")
		     ("name" "li")
		     ("signingKey" "&AD305831DD33E62F9AD587718D4E5E6999CD84EA")))
		   ("ghq"
		    (("root" "/git")))
		   ("github"
		    (("user" "maisiliym"))))))

(define source-home-profile (source-profile '~/.home-profile))

(define sshcontrol-file 
  (mixed-text-file "sshcontrol"
                   "AD305831DD33E62F9AD587718D4E5E6999CD84EA"))

(define gnupg-conf '())

(define data-directory "/data/li")

;; (define haki-base-configuration
;;   (base-home-configuration
;;    (guix-symlink "/var/guix/profiles/per-user/li/home/.home-profile")
;;    (guix-config-symlink (string-append data-directory "/.config/guix"))
;;    (local-symlink (string-append data-directory "/.local"))
;;    (cache-symlink (string-append data-directory "/.cache"))))

(home
 (data-directory "/data/li")
 ;(base-configuration haki-base-configuration)
 (configurations
  (list
   (symlink-file-home "/data/li/git" "git")
   (symlink-file-home "/data/li/.gnupg" ".gnupg")
   (symlink-file-home "/data/li/git/imaks" ".config/emacs")
   (symlink-file-home "/data/li/git/li/sway.conf" ".config/sway/config")
   (symlink-file-home gitconfig-file ".config/git/config")
   (user-home
    ssh-home-type
    (ssh-configuration
     (known-hosts
      (list
       (ssh-known-host-configuration
        (names '("github.com"))
	(algo "ssh-rsa")
        (key "AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="))))))
   (user-home
    zsh-home-type
    (zsh-configuration
     (env (list shell-env zsh-env))
     (profile (list source-home-profile))
     (rc (list interactive-zsh-env interactive-zsh zsh-coleremak))
     (history "/data/li/.local/share/zsh/history")))
   (user-home
    bash-home-type
    (bash-configuration
     (rc (reverse (append default-bashrc
			  (list source-home-profile))))
     (profile (append default-bash-profile
                      (list "EDITOR=emacs\n")))
     (history "/data/li/.local/share/bash/history")))
   (user-home package-profile-home-type
	      (list
	       dvtm abduco zsh fzf perl
	       fd tokei
	       fontconfig
	       font-google-material-design-icons
	       font-awesome
	       ncurses
	       git ghq
	       gnupg pinentry-tty
	       wofi foot waybar swaylock swayidle
	       redshift-wayland
	       nyxt
	       mpv
	       pinentry-emacs
	       emacs-next-pgtk
	       emacs-pinentry
	       emacs-xah-fly-keys
	       emacs-which-key
	       emacs-helpful
	       emacs-org
	       emacs-org-roam
	       emacs-doom-modeline emacs-doom-themes
	       emacs-deadgrep
	       emacs-treemacs
	       emacs-fish-completion fish
	       emacs-adaptive-wrap
	       emacs-geiser ; scheme
	       emacs-geiser-guile
	       emacs-guix ; broken
	       emacs-eshell-bookmark
	       emacs-esh-autosuggest
	       emacs-eshell-prompt-extras
	       emacs-eshell-syntax-highlighting
	       emacs-lispy
	       emacs-shen-mode
	       emacs-cider ; clojure
	       emacs-slime sbcl ; common-lisp
	       emacs-nix-mode
	       emacs-magit
	       emacs-forge
	       emacs-git-undo
	       emacs-yasnippet
	       emacs-company
	       emacs-selectrum
	       emacs-orderless
	       emacs-consult
	       emacs-embark
	       emacs-posframe
	       emacs-prescient
	       emacs-marginalia
	       emacs-ghq
	       ;; emacs-diff-hl
	       emacs-git-gutter
	       emacs-expand-region
	       emacs-multiple-cursors
	       emacs-projectile
	       emacs-sx ; stackexchange
	       transmission transmission-remote-cli
	       youtube-dl)))))
