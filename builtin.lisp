(in-package :thierry-technologies.com/2011.09.clone)


#| Cloning for builin atoms |#

(defmethod clone ((object symbol) next)
  (if (symbol-package object)
      object
      (make-symbol (symbol-name object))))

(defmethod clone ((object number) next)
  (declare (ignore next))
  object)

(defmethod clone ((object character) next)
  (declare (ignore next))
  object)

(defmethod clone ((object function) next)
  (declare (ignore next))
  object)

#| Cloning for some built-in sequences |#

  ; although they can be used for different things, we consider that
  ; the default use of cons cells are lists
(defmethod clone ((object cons) next)
  (mapcar next object))

(defmethod clone ((object array) next)
  (let ((copy (make-array (array-dimensions object)
			  :element-type (array-element-type object)
			  :adjustable (adjustable-array-p object)
			  :fill-pointer (handler-case
					    (fill-pointer object)
					  (type-error () nil)))))
    (dotimes (index (apply #'* (array-dimensions object)) copy)
      (setf (row-major-aref copy index)
	    (funcall next (row-major-aref object index))))))

#| Cloning for hash tables |#

(defmethod clone ((object hash-table) next)
  (let ((copy (make-hash-table
	       :test (hash-table-test object)
	       :size (hash-table-size object)
	       :rehash-size (hash-table-rehash-size object)
	       :rehash-threshold (hash-table-rehash-threshold object)
	       #+sbcl :weakness #+sbcl (sb-ext:hash-table-weakness object))))
    (maphash (lambda (k v)
	       (setf (gethash (funcall next k) copy) (funcall next v)))
	     object)
    copy))


#| Cloning for CLOS objects |#

(defgeneric slot-clone (slot source target next))

(defmethod slot-clone ((slot closer-mop:effective-slot-definition) source target next)
  (let ((name (closer-mop:slot-definition-name slot)))
    (setf (slot-value target name) (funcall next (slot-value source name)))))

(defgeneric shared-clone (object clone))
(defmethod shared-clone (object clone))

(defmethod clone ((object standard-object) next)
  (let* ((class (class-of object))
	 (clone (make-instance class))
	 (slots (closer-mop:class-slots class)))
    (loop for slot in slots
       do (slot-clone slot object clone next))
    (shared-clone object clone)
    clone))
