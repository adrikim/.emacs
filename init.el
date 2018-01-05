;;; private/akim/init.el -*- lexical-binding: t; -*-
;;; private/akim/config.el -*- lexical-binding: t; -*-

;; You need this for any packages installed to show up, I think
(require 'package)
;; NEVER EVER use (package-initialize), gives me sporadic nlinums all disappearing issues

(require 'ripgrep)
(require 'ag)
(require 'jedi)
(require 'vagrant)
(require 'vagrant-tramp)
(require 'hideshowvis)
(require 'indent-guide)
(hideshowvis-symbols)

;; Not sure why I had this one in the first place...
;(setq-default mode-line-format nil)

; I would use these if the fonts weren't already perfectly fine/emacs could find the fonts...
;(set! :font "Operator Mono" :size 18)
;(set! :big-font "Operator Mono" :size 18)
;(set! :variable-font "Operator Mono" :size 18)
;(set! :unicode-font "Operator Mono" :size 18)

;; Allow for copy/paste from the system clipboard via middle-click
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(defun +akim*no-authinfo-for-tramp (orig-fn &rest args)
  "Don't look into .authinfo for local sudo TRAMP buffers."
  (let ((auth-sources (if (equal tramp-current-method "sudo") nil auth-sources)))
    (apply orig-fn args)))
(advice-add #'tramp-read-passwd :around #'+akim*no-authinfo-for-tramp)

;; When you select a region, kill instead of killing one line only
(defun kill-line-or-region ()
 "kill region if active only or kill line normally"
  (interactive)
  (if (region-active-p)
      (call-interactively 'kill-region)
    (call-interactively 'kill-line)))
  (global-set-key (kbd "C-k") 'kill-line-or-region)

;; Set startup message in minibuffer
(defun display-startup-echo-area-message ()
  (message (propertize " >patrolling the minibuffer almost makes you wish for a nuclear winter" 'face '(:foreground "Green"))))

;; Show trailing whitespace
(setq-default show-trailing-whitespace t)

;; Auto indent on newline
(add-hook 'python-mode-hook '(lambda ()
  (local-set-key (kbd "RET") 'newline-and-indent)))

;; No prompt when you kill the current buffer, it'll be killed automatically
(global-set-key (kbd "C-x k") 'kill-this-buffer)

;; Better C^a / beginning of line
(defun smarter-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

;; remap C-a to `smarter-move-beginning-of-line'
(global-set-key [remap move-beginning-of-line]
                'smarter-move-beginning-of-line)

;; No strict indenting for multiline python docstrings/strings
(defun my-python-indent-line ()
  (if (eq (car (python-indent-context)) :inside-docstring)
      'noindent
    (python-indent-line)))

;; Have my-python-indent-line hook into general python mode
(defun my-python-mode-hook ()
  (setq indent-line-function #'my-python-indent-line))
(add-hook 'python-mode-hook #'my-python-mode-hook)

;; Package to add vertical lines based on your current block
;; WARNING- big files will stutter with this
;;(require 'indent-guide)
;;(indent-guide-global-mode)

; Use vagrant/vagrant-tramp
(require 'vagrant)
(require 'vagrant-tramp)

;; Remap C-z from suspend emacs to undo
(global-unset-key (kbd "C-z"))
(global-set-key (kbd "C-z") 'undo)

;; Remap f5 to eval-buffer
(global-set-key (kbd "<f5>") 'eval-buffer)

;; Set git-gutter character to something other than a +/- because it looks like shit
;;(setq git-gutter:modified-sign "❚")

;; from hlissner
(after! smartparens
  ;; Auto-close more conservatively
  (let ((unless-list '(sp-point-before-word-p
                       sp-point-after-word-p
                       sp-point-before-same-p)))
    (sp-pair "'"  nil :unless unless-list)
    (sp-pair "\"" nil :unless unless-list))
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "(" nil :post-handlers '(("||\n[i]" "RET") ("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p))
  (sp-pair "[" nil :post-handlers '(("| " " "))
           :unless '(sp-point-before-word-p sp-point-before-same-p)))

;; Enable hideshowvis mode
;; (autoload 'hideshowvis-enable "hideshowvis" "Highlight foldable regions")
;; (autoload 'hideshowvis-minor-mode
;;  "hideshowvis"
;;  "Will indicate regions foldable with hideshow in the fringe."
;;  'interactive)
;; (dolist (hook (list 'emacs-lisp-mode-hook
;;                    'c++-mode-hook
;;                    'python-mode-hook))
;;  (add-hook hook 'hideshowvis-enable))

 ;; Always enable hs-minor-mode
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-set-key (kbd "<f1>") 'hs-toggle-hiding)

;; Enable jedi mode when you enter python-mode
(add-hook 'python-mode-hook #'jedi:setup)
(setq jedi:complete-on-dot t)
