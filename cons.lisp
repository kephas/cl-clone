(in-package :thierry-technologies.com/2011.09.clone)

#|

Alternative cloning functions for cons cells

|#

(defun deep-clone-pair (object next)
  (cons (funcall next (car object))
	(funcall next (cdr object))))


(defun deep-clone-assoc (object next &key key (datum t))
  (mapcar (lambda (pair)
	    (cons (if key (funcall next (car pair)) (car pair))
		  (if datum (funcall next (cdr pair)) (cdr pair))))
	  object))

(defun shallow-clone-assoc (object)
  (deep-clone-assoc object nil :datum nil))


(defun deep-clone-tree (object next)
  (labels ((%clone (part)
	     (typecase part
	       (cons (deep-clone-tree part next))
	       (t (funcall next part)))))
    (when object
      (cons (%clone (car object)) (%clone (cdr object))))))

(defun shallow-clone-tree (object)
  (deep-clone-tree object #'identity))
