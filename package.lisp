(defpackage :thierry-technologies.com/2011.09.clone
  (:use :cl :alexandria)
  (:nicknames :clone)
  (:export #:clone
  	   #:shallow-clone #:deep-clone #:level-clone
	   #:slot-clone #:shared-clone
	   #:deep-clone-pair
	   #:deep-clone-assoc #:shallow-clone-assoc
	   #:deep-clone-tree #:shallow-clone-tree))
