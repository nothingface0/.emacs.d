;;; Config --- Summary
;;; Commentary:
;;; Summary:

;;; Code:
(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (/= (length buffer-file-name) 0)
      (if (string-match (car my-pair) buffer-file-name)
		  (funcall (cdr my-pair))
		(message "Could not match regex \"%s\" to buffer file name, not enabling %s" (car my-pair) (cdr my-pair)))))

(setq package-list '(use-package sr-speedbar markdown-mode tabbar arduino-mode flycheck magit autopair nocomments-mode highlight-doxygen auto-complete auctex jedi web-mode rainbow-mode shell-here js2-mode powershell transient highlight-indent-guides dakrone-theme json-mode yaml-mode auto-complete-auctex ac-math prettier-js python-black clang-format+ modeline-posn swiper org))
(setq package-archives '(("elpa" . "https://tromey.com/elpa/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
						 ("org" . "https://orgmode.org/elpa/")))

(setq create-lockfiles nil;
	  default-input-method "greek"
	  )

(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  (add-to-list 'package-archives '("org" . "https://orgmode.org/elpa/") t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;;install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

;; Autocomplete configuration
(ac-config-default)
(global-auto-complete-mode 1)

;; clang format for C/C++
(add-hook 'c-mode-common-hook #'clang-format+-mode)

;; Enable server mode
(server-start)

;; Enable speedbar
;; (speedbar 1)
;; (sr-speedbar-open)

;; Highlight doxygen
;; (highlight-doxygen-global-mode 1)

;; Activate auto-complete for latex modes (AUCTeX or Emacs' builtin one).
;; (add-to-list 'ac-modes 'latex-mode)

;; Activate ac-math.
;; (eval-after-load "latex"
;;   '(when (featurep 'auto-complete)
;;      ;; See https://github.com/vspinu/ac-math
;;      (require 'ac-math)
;;      (defun ac-latex-mode-setup ()       ; add ac-sources to default ac-sources
;;        (setq ac-sources
;; 			 (append '(ac-source-math-unicode ac-source-math-latex ac-source-latex-commands)
;; 					 ac-sources)))
;;      (add-hook 'LaTeX-mode-hook 'ac-latex-mode-setup)))

;; Enable line numbers on side
(if (< emacs-major-version 26)
	(global-linum-mode 1)
  (global-display-line-numbers-mode))

;; Config for C style
(setq-default c-default-style "bsd"
			  c-basic-offset 4
			  tab-width 4
			  indent-tabs-mode t
			  )

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(setq inhibit-startup-message t)
(setq tool-bar-mode -1)

;; Theme, packages and customization
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(custom-enabled-themes (quote (dakrone)))
 '(custom-safe-themes
   (quote
	("246cd0eb818bfd347b20fb6365c228fddf24ab7164752afe5e6878cb29b0204e" "2593436c53c59d650c8e3b5337a45f0e1542b1ba46ce8956861316e860b145a0" "28caf31770f88ffaac6363acfda5627019cac57ea252ceb2d41d98df6d87e240" "a24c5b3c12d147da6cef80938dca1223b7c7f70f2f382b26308eba014dc4833a" default)))
 '(package-selected-packages
   (quote
	(swiper modeline-posn cuda-mode arduino-mode clang-format+ prettier-js python-black exec-path-from-shell json-mode yaml-mode dakrone-theme python-pep8 js2-mode powershell jedi sr-speedbar tabbar flycheck magit autopair nocomments-mode highlight-doxygen auto-complete auctex markdown-mode shell-here rainbow-mode web-mode transient highlight-indent-guides use-package)))
 '(tab-width 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code" :foundry "outline" :slant normal :weight normal :height 90 :width normal)))))

(require 'flycheck)
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(setq flycheck-python-pycompile-executable "python")
;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
			  (append flycheck-disabled-checkers
					  '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)
;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
			  (append flycheck-disabled-checkers
					  '(json-jsonlist)))

(use-package flycheck-yamllint
  :ensure t
  :defer t
  :init
  (progn
    (eval-after-load 'flycheck
      '(add-hook 'flycheck-mode-hook 'flycheck-yamllint-setup))))

(setq python-indent-guess-indent-offset-verbose nil)

;; Python black formatter
(use-package python-black
  :demand t
  :after python)

(setq-default python-black-on-save-mode t)

;; Enable Arduino major mode
;; (add-to-list 'load-path "~/.emacs.d/vendor/arduino-mode")
(setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist))
(autoload 'arduino-mode "arduino-mode" "Arduino editing mode." t)
(add-hook 'arduino-mode
		  (lambda ()
			(setq comment-start "//")))

;; Add jedi (not really sure if I'm using it)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)

;; Setup web-mode for front-end types of files
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; Associate JS files with js2-mode
(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-mode))

;; prettier-js
;; https://github.com/prettier/prettier-emacs
;; Windows require diffutils from chocolatey
(require 'prettier-js)
(add-hook 'js2-mode-hook 'prettier-js-mode)
;; Disable for web-mode, incompatible with Django
;; (add-hook 'web-mode-hook 'prettier-js-mode)

(setq prettier-js-args '(
  "--trailing-comma" "all"
  "--bracket-spacing" "false"
  "--single-quote"
  "--tab-width" "4"
  ))

;; Only enable prettier mode for js files, as prettier
;; does not yet support Django ://
(add-hook 'web-mode-hook #'(lambda ()
                            (enable-minor-mode
                             '("\\.jsx?\\'" . prettier-js-mode))))




;; Save session on exit
(desktop-save-mode 1)

;; Enable tabbar
(tabbar-mode 1)

;; Indentation
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
(setq highlight-indent-guides-method 'character)

;; Rainbow mode enable
;; (add-hook 'prog-mode-hook 'rainbow-mode)

;; Enable web-mode for scss files
(add-hook 'scss-mode-hook #'web-mode)

;; Change comment format for JavaScript in web-mode
(setq-default web-mode-comment-formats
              '(("java"       . "/*")
                ("javascript" . "//")
                ("php"        . "/*")))

;; Change comment format for C in C mode
(add-hook 'c-mode-hook (lambda () (c-toggle-comment-style -1)))

(defun vhdl-write-hook ()
  (interactive)
  (when (eq major-mode 'vhdl-mode)
	(vhdl-beautify-buffer)))

(add-hook 'before-save-hook 'vhdl-write-hook)

(defun arduino-indent-hook ()
  "Arduino hook to fix indentation."
  (setq c-basic-offset 4)
  (setq tab-width 4))
(add-hook 'arduino-mode-hook 'arduino-indent-hook)

;; custom key combinations
(defun move-line-up ()
  "Move up the current line."
  (interactive)
  (transpose-lines 1)
  (forward-line -2)
  (indent-according-to-mode))

(defun move-line-down ()
  "Move down the current line."
  (interactive)
  (forward-line 1)
  (transpose-lines 1)
  (forward-line -1)
  (indent-according-to-mode))
(global-set-key [(control shift up)]  'move-line-up)
(global-set-key [(control shift down)]  'move-line-down)

(defun explorer-here()
  "Open File explorer in current dir (Windows)."
  (interactive)
  (if default-directory
	  ;; (message "System is: %s" system-type)
	  (if (string-equal system-type "windows-nt")
		  (browse-url-of-file (expand-file-name default-directory))
		(let ((process-connection-type nil));
		  (start-process "explorer" "*Messages*" "xdg-open" ".")))

	;; (browse-file-directory)))
    (error "No `default-directory' to open")))
;; (shell-command "start .")

(global-set-key [?\C-\!] 'explorer-here)

;; Duplicate line
(global-set-key "\C-c\C-f" "\C-a\C- \C-n\M-w\C-y")

;; Magit status
(global-set-key "\C-c\g" 'magit-status)

;; Delete trailing whitespace
(global-set-key "\C-c\w" 'delete-trailing-whitespace)

;; LaTeX settings
(setq-default TeX-engine 'xetex)
(setq-default TeX-command-extra-options "-output-directory=build")
(add-hook 'LaTeX-mode-hook 'turn-on-auto-fill)
(setq-default TeX-engine 'xetex)
(setq-default TeX-PDF-mode t)
(setq TeX-auto-save t)
(setq TeX-parse-self t)

;; Count selected lines/chars
(setq-default size-indication-mode 1)

;; Swiper
(global-set-key (kbd "C-s") 'swiper)
(setq ivy-display-style 'fancy)


(defun user--asm-mode-hook ()
  "Assembly mode hook."
  (setq
   ;; Indent using tabs by default.
   indent-tabs-mode t)

  (user/gnu-global-enable))


(define-derived-mode arm-mode asm-mode "ARM"
  "Major mode for editing ARM assembler code."
  ;; Unset ; key.
  (local-unset-key (vector asm-comment-char))
  (set (make-local-variable 'asm-comment-char) ?@)
  (local-set-key (vector asm-comment-char) 'asm-comment)
  ;; Update syntax for new comment char.
  (set-syntax-table (make-syntax-table asm-mode-syntax-table))
  (modify-syntax-entry asm-comment-char "< b")
  ;; Fix one level comments.
  (set (make-local-variable 'comment-start) (string asm-comment-char)))

(defun insert-date (prefix)
    "Insert the current date. With prefix-argument, use ISO format. With two prefix arguments, write out the day and month name."
    (interactive "P")
    (let ((format (cond
				   ((not prefix) "%Y-%m-%d %H:%M")))
                   ;; ((not prefix) "%d.%m.%Y")
                   ;; ((equal prefix '(4)) "%Y-%m-%d %H:%M")
                   ;; ((equal prefix '(16)) "%A, %d. %B %Y")))
          (system-time-locale "el"))
      (insert (format-time-string format))))
    (global-set-key (kbd "C-c d") 'insert-date)

(defun setup-org-mode ()
  "Setup `org-mode`."
  (add-to-list 'auto-mode-alist
	       '("\\.org$" . org-mode) t)
  (add-hook 'org-mode-hook
            (lambda ()
              (local-set-key (kbd "\C-cl") 'org-store-link)
              (local-set-key (kbd "\C-ca") 'org-agenda)
              (setq org-log-done t
                    org-src-fontify-natively t))))

(setup-org-mode)
(provide '.emacs)
;;; init.el ends here
