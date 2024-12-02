;;; hyprlang-ts-mode.el --- tree-sitter support for Hyprlang  -*- lexical-binding: t; -*-

;; Copyright (C) 2024

;; Author     : Nathan Melaku <cy6ass@gmail.com>
;; Maintainer : Nathan Melaku <cy6ass@gmail.com>
;; Created    : November 2024
;; Keywords   : hyprland hyprlang languages tree-sitter

;;; Commentary:
;;

;;; Code:
(require 'treesit)

(defcustom hyprlang-ts-mode-indent-offset 2
  "Number of spaces for each indentation step in `hyprlang-ts-mode'"
  :version "29.4"
  :type 'integer
  :safe 'integerp
  :group 'hyprlang)

(defvar hyprlang-ts-font-lock-rules
  '(;; Hyperlang font locking rules

    :language hyprlang
    :override t
    :feature comment
    ((comment) @font-lock-comment-face)

    :language hyprlang
    :override t
    :feature section
    ((section (name) @font-lock-type-face))

    :language hyprlang
    :override t
    :feature assignment
    ((assignment (name) @font-lock-builtin-face "=" @font-lock-operator-face))

    :language hyprlang
    :override t
    :feature keyword
    ((keyword (name) @font-lock-keyword-face "=" @font-lock-operator-face))

    :language hyprlang
    :override t
    :feature exec
    ((exec "exec" @font-lock-keyword-face "=" @font-lock-operator-face)
     (exec "exec-once" @font-lock-keyword-face "=" @font-lock-operator-face))

    :language hyprlang
    :override t
    :feature source
    ((source "source" @font-lock-keyword-face "=" @font-lock-operator-face))

    :language hyprlang
    :override t
    :feature variable
    ((variable) @font-lock-variable-name-face)

    :language hyprlang
    :override t
    :feature string
    ((string) @font-lock-string-face)

    :language hyprlang
    :override t
    :feature string_literal
    ((string_literal) @font-lock-string-face)

    :language hyprlang
    :override t
    :feature number
    ((number) @font-lock-number-face)

    :language hyprlang
    :override t
    :feature boolean
    ((boolean) @font-lock-number-face)

    :language hyprlang
    :override t
    :feature mod
    ((mod) @font-lock-variable-use-face)))

(defvar hyprlang-ts-mode--indent-rules
  ;; Hyprlang indentation rules
  `((hyprlang
     ((parent-is "section") parent hyprlang-ts-mode-indent-offset)
     ((node-is "section") parent 0)
     ((node-is "comment") parent 0)
     ((node-is ,(regexp-opt '("assignment" "keyword" "exec" "declaration"))) prev-sibling 0)
     (no-node parent 0))))

(defvar hyprlang-ts-mode--syntax-table
  (let ((syntax-table (make-syntax-table)))
    (modify-syntax-entry ?# "<" syntax-table)
    (modify-syntax-entry ?\n ">#" syntax-table)
    syntax-table)
  "Syntax table for `hyprlang-ts-mode'.")

(defun hyprlang-ts-setup ()
  "Setup treesit for hyprlang. This function is the core of the hyprlang-ts-mode.
   it sets up font locking and indentation rules."
  ;; comment starts with # and it doesn't need and end symbol
  (setq-local comment-start "#")
  (setq-local comment-end "")

  ;; set font lock
  (setq-local treesit-font-lock-settings
              (apply #'treesit-font-lock-rules
                     hyprlang-ts-font-lock-rules))
  (setq-local font-lock-defaults nil)
  (setq-local treesit-font-lock-feature-list
              '((comment)
                (section assignment keyword exec source declaration)
                (variable string string_literal number boolean mod)))

  ;; set indentation rules
  (setq-local treesit-simple-indent-rules hyprlang-ts-mode--indent-rules)
  (treesit-major-mode-setup))

(define-derived-mode hyprlang-ts-mode prog-mode "Hyprlang"
  "A mode for editing Hyprland configuration file"
  :group 'hyprlang
  :syntax-table hyprlang-ts-mode--syntax-table
  (unless (treesit-ready-p 'hyprlang)
    (error "Tree-sitter for hyprlang isn't available"))
  (hyprlang-ts-setup))

(if (treesit-ready-p 'hyprlang)
    (add-to-list 'auto-mode-alist '("/hypr/.*\\.conf\\'" . hyprlang-ts-mode)))

(provide 'hyprlang-ts-mode)

;;; hyprlang-ts-mode.el ends here
