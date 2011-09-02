(defpackage :thierry-technologies.com/2011/09/clone-system
  (:use :common-lisp :asdf))

(in-package :thierry-technologies.com/2011/09/clone-system)

(defsystem "clone"
  :description "Generic facility to copy objects"
  :version "1.0"
  :author "Pierre Thierry <pierre@nothos.net>"
  :licence "GPL"
  :components ((:file "clone")))
