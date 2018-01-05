;;; private/akim/packaged.el -*- lexical-binding: t; -*-

;; Put eg. (package! vagrant) if you want to declare that you want to use the vagrant package
;; When you run make, doomemacs detects that it's a package you use and will install upon make

;; Delete the package! line or comment out and re-make to remove the package

;; However, after installing, you need to have (require 'package) up top as well as a (require 'PACKAGE_NAME)
;; per package in init.el to load the newly installed packages. Needs to be there all the time, not just
;; once right after installation.

(package! vagrant)
(package! vagrant-tramp)
(package! hideshowvis)
(package! jedi)
(package! ripgrep)
(package! yaml-mode)
(package! ag)
(package! indent-guide)
