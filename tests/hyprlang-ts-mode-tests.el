;;; hyprlang-ts-mode-tests.el --- Tests for Tree-sitter-based Hyprlang mode  -*- lexical-binding: t; -*-

;;; Commentary:

;;; Code:
(require 'ert)
(require 'ert-x)
(require 'treesit)

(declare-function treesit-install-language-grammar "treesit.c")

(if (and (treesit-available-p) (boundp 'treesit-language-source-alist))
    (unless (treesit-language-available-p 'hyprlang)
      (add-to-list 'treesit-language-source-alist
                   '(hyprlang "https://github.com/tree-sitter-grammars/tree-sitter-hyprlang" "master"))
      (treesit-install-language-grammar 'hyprlang)))

(ert-deftest hyprlang-ts-mode-test-indentation ()
  (skip-unless (treesit-ready-p 'hyprlang))
  (ert-test-erts-file (ert-resource-file "indentation.erts")))

(ert-deftest hyprlang-ts-mode-test-font-face ()
  (skip-unless (treesit-ready-p 'hyprlang))
  (ert-test-erts-file (ert-resource-file "font-face.erts")))

(provide 'hyprlang-ts-mode-tests)
;;; hyprlang-ts-mode-tests.el ends here
