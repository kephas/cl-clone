#|

Basic cloning helpers for cons cells

|#

(defun deep-clone-pair (object fall-back)
  (cons (funcall fall-back (car object))
	(funcall fall-back (cdr object))))

(defun shallow-clone-pair (object)
  (deep-clone-pair object #'identity))


(defun deep-clone-list (object fall-back)
  (when object
    (cons (funcall fall-back (first object)) (shallow-clone-list (rest object) fall-back))))

(defun shallow-clone-list (object)
  (deep-clone-list object #'identity))


(defun deep-clone-tree (object fall-back)
  (labels ((clone (part)
	     (typecase part
	       (cons (deep-clone-tree part fall-back))
	       (t (funcall fall-back part)))))
    (when object
      (cons (clone (car object)) (clone (cdr object))))))

(defun shallow-clone-tree (object)
  (deep-clone-tree object #'identity))


#|

Basic cloning helpers for arrays

|#

(defun deep-clone-array (object fall-back)
  (let ((copy (make-array (array-dimensions object)
			  :element-type (array-element-type object)
			  :adjustable (adjustable-array-p object)
			  :fill-pointer (handler-case
					    (fill-pointer object)
					  (type-error () nil)))))
    (dotimes (index (apply #'* (array-dimensions object)) copy)
      (setf (row-major-aref copy index)
	    (funcall fall-back (row-major-aref object index))))))

(defun shallow-clone-array (object)
  (deep-clone-array object #'identity))
