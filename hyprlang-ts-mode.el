(require 'treesit)
(defvar hyprlang-ts-font-lock-rules
  '(;; Hyperlang font locking
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
    ((exec) @font-lock-keyword-face)

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
    ((mod) @font-lock-variable-use-face)
    ))

(defun hyprlang-ts-setup ()
  "Setup treesit for hyprlang"
  (setq-local treesit-font-lock-settings
              (apply #'treesit-font-lock-rules
                     hyprlang-ts-font-lock-rules))
  (setq-local font-lock-defaults nil)
  (setq-local treesit-font-lock-feature-list
              '((comment)
                (section assignment keyword exec declaration)
                (variable string string_literal number boolean mod)))
  (setq-local treesit-simple-indent-rules
              `((hyprlang
                 ((parent-is "section") parent 4)
                 ((node-is "section") parent 0)
                 ((node-is "comment") parent 0)
                 ((node-is ,(regexp-opt '("assignment" "keyword" "exec" "declaration"))) prev-sibling 0)
                 (no-node parent 0))))
  (treesit-major-mode-setup))

(define-derived-mode hyprlang-ts-mode prog-mode "Hyprlang"
  "A mode for Hyprland configuration file"
  (when (treesit-ready-p 'hyprlang)
    (message "Hyprlang mode enabled")
    (hyprlang-ts-setup)))

(provide 'hyprlang-ts-mode)
