(in-package :thierry-technologies.com/2011.09.clone)

#| Generic functions for object cloning |#

(defgeneric clone (object next))


#| Shallow and deep cloning |#

(defun shallow-clone (object)
  (clone object #'identity))

(defun deep-clone (object)
  (clone object #'deep-clone))

(defun level-clone (object level)
  (if (zerop level)
      object
      (clone object (lambda (x) (level-clone x (1- level))))))
