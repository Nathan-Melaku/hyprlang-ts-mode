;;; hyprlang-ts-mode.el --- Major mode for editing hyprland configuration files -*- lexical-binding: t -*-

;; Copyright (C) 2024

;; Author     : Nathan Melaku <cy6ass@gmail.com>
;; Maintainer : Nathan Melaku <cy6ass@gmail.com>
;; Created    : November 2024
;; Keywords   : hyprland hyprlang languages tree-sitter
;; Version    : 0.0.1
;; URL        : https://github.com/Nathan-Melaku/hyprlang-ts-mode
;; Package-Requires: ((emacs "29.1"))

;;; Commentary:
;; Major mode for editing hyprland configuration files, powered by treesitter.  It provides syntax highlighting,
;; indentation.  It's tree-sitter grammer is located at `https://github.com/tree-sitter-grammars/tree-sitter-hyprlang'

;;; Code:

(require 'treesit)

(defcustom hyprlang-ts-mode-indent-offset 2
  "Number of spaces for each indentation step in `hyprlang-ts-mode'."
  :version "29.4"
  :type 'integer
  :safe 'integerp
  :group 'hyprlang)

(defvar hyprlang-ts-mode--font-lock-rules
  ;; Hyperlang font locking rules
  (treesit-font-lock-rules

   :language 'hyprlang
   :feature 'comment
   `((comment) @font-lock-comment-face)

   :language 'hyprlang
   :feature 'special
   `([ "source" "exec" "exec-once" ] @font-lock-keyword-face)

   :language 'hyprlang
   :feature 'keyword
   `((keyword (name) @font-lock-keyword-face))

   :language 'hyprlang
   :feature 'assignment
   `((assignment (name) @font-lock-property-use-face))

   :language 'hyprlang
   :override t
   :feature 'section
   `((section (name) @font-lock-type-face))

   :language 'hyprlang
   :override t
   :feature 'section-device
   `((section device: (device_name) @font-lock-type-face))

   :language 'hyprlang
   :feature 'variable
   `((variable) @font-lock-variable-name-face)

   :language 'hyprlang
   :feature 'dollar
   `("$" @font-lock-punctuation-face)

   :language 'hyprlang
   :feature 'boolean
   `((boolean) @font-lock-number-face)

   :language 'hyprlang
   :feature 'mod
   `((mod) @font-lock-constant-face)

   :language 'hyprlang
   :feature 'builtin
   `([ "rgb" "rgba" ] @font-lock-builtin-face)

   :language 'hyprlang
   :feature 'number
   `([ (number) (legacy_hex) (angle) (hex) (display) (position) ] @font-lock-number-face)

   :language 'hyprlang
   :feature 'deg
   `("deg" @font-lock-type-face)

   :language 'hyprlang
   :feature 'delimit
   `([ "," ":" ] @font-lock-delimiter-face)

   :language 'hyprlang
   :feature 'bracket
   `([ "(" ")" "{" "}" ] @font-lock-bracket-face)

   :language 'hyprlang
   :feature 'operator
   `([ "=" "-" "+" ] @font-lock-operator-face)

   :language 'hyprlang
   :feature 'string
   `([ (string) (string_literal) ] @font-lock-string-face)))

(defvar hyprlang-ts-mode--indent-rules
  ;; Hyprlang indentation rules
  `((hyprlang
     ((node-is "}") parent-bol 0)
     ((parent-is "configuration") column-0 0)
     ((parent-is "comment") parent-bol 1)
     ((parent-is "section") parent-bol hyprlang-ts-mode-indent-offset))))

(defvar hyprlang-ts-mode--syntax-table
  (let ((syntax-table (make-syntax-table)))
    (modify-syntax-entry ?# "<" syntax-table)
    (modify-syntax-entry ?\n ">#" syntax-table)
    syntax-table)
  "Syntax table for `hyprlang-ts-mode'.")

(defun hyprlang-ts-setup ()
  "Setup treesit for hyprlang.
This function is the core of the`hyprlang-ts-mode'.
it sets up font locking and indentation rules."
  (treesit-parser-create 'hyprlang)
  ;; comment starts with # and it doesn't need and end symbol
  (setq-local comment-start "#")
  (setq-local comment-end "")

  ;; Navigation
  (setq-local treesit-defun-type-regexp "section")


  ;; set font lock
  (setq-local treesit-font-lock-settings hyprlang-ts-mode--font-lock-rules)
  (setq-local treesit-font-lock-feature-list
              '((comment special deg delimit dollar bracket)
                (section section-device assignment keyword declaration)
                (builtin operator variable string number boolean mod)))

  ;; set indentation rules
  (setq-local treesit-simple-indent-rules hyprlang-ts-mode--indent-rules)
  (treesit-major-mode-setup))

(define-derived-mode hyprlang-ts-mode prog-mode "Hyprlang"
  "A mode for editing Hyprland configuration file."
  :group 'hyprlang
  :syntax-table hyprlang-ts-mode--syntax-table

  (unless (treesit-ready-p 'hyprlang)
    (error "Tree-sitter for hyprlang isn't available"))

  (hyprlang-ts-setup))

(if (treesit-ready-p 'hyprlang)
    (add-to-list 'auto-mode-alist '("/hypr/.*\\.conf\\'" . hyprlang-ts-mode)))

(provide 'hyprlang-ts-mode)

;;; hyprlang-ts-mode.el ends here
