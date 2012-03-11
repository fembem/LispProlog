;;; Leo deCandia
;;; ICS361
;;; Aassignment 4


;;(load "C:\\Users\\Leo\\ICS361\\LispProlog\\a4.cl")

(defclass Node ()
  ((name :accessor name :initarg :name :type 'symbol
         :documentation "the name of the Concept or Relation"))
  (:documentation "The top level class, subclasses include Concepts and Relations"))

;(print "defined Node")

(defclass Concept (Node)
  ((froms :type list :accessor froms :initarg :froms :initform nil
          :documentation "a list of the Relations whose from slot is this Concept")
   (tos :type list :accessor tos :initarg :tos :initform nil
        :documentation "a list of the Relations whose to slot is this Concept"))
  (:documentation "An physical or conceptual object"))

;(print "defined Concept")

(defclass Relation (Node)
  ((from :type Concept :accessor from :initarg :from
         :documentation "the Concept that this Relation is from")
   (to :type Concept :accessor to :initarg :to
       :documentation "the Concept that this Relation is to"))
  (:documentation "A relationship between two Concepts"))

(defun make-concept (class &optional name)
  "makes and returns an instance of a concept of type class and with name set to name if name is given"
  (make-instance class :name name))

;(print "defined make-concept")

(defun make-relation (class &optional name &key from to)
  "makes and returns an instance of relation of type class, with names set to name if given and
  with the from and to slots given by the respective optional parameters"
  (let ((instance (make-instance class :name name :from from :to to)))
    ;(if from (setf (froms from) (cons instance (froms from))))
    ;call this just so the froms slot will be updated in the from concept by the :before and :after methods
    (if from (set-from instance from))
    ;(if to (setf (tos to) (cons instance (tos to))))
    ;call this just so the froms slot will be updated in the from concept by the :before and :after methods
    (if to (set-to instance to))
    instance))

;(print "defined make-relation")

(defmacro define-concept (class-name)
  "creates a class named class-name to represent a concept, and binds it to a symbol with name class-name"
  `(setq ,class-name (defclass ,class-name (Concept) () )))

;(print "defined define-concept")

(defmacro define-relation (class-name from-concept to-concept)
  "creates a class named class-name to represent a relation between a concept of type from-concept and
  a concept of type to-concept, and binds it to a symbol with name class-name"
  `(setq ,class-name (defclass ,class-name (Relation) ((from :type ,from-concept) (to :type ,to-concept)) )))

;(print "defined define-relation")

(defgeneric get-to (concept relation-class)
  (:documentation "get the concept in the to slot of any relation of type relation-class
   having the given concept in its from slot"))

(defmethod get-to ((concept Concept) (relation-class Standard-Class))
  "returns the concept in the to slot of a relation"
  (find-to-of-matching-relation relation-class (froms concept)))

(defun find-to-of-matching-relation (relation-class froms-list)
  "given a relation class and a list of relations, find a relation in that list that has a non-null to slot"
  (cond ((null froms-list) nil)
        ((and (eq (class-of (car froms-list)) relation-class)
              (to (car froms-list)))
         (to (car froms-list)))
        (t (find-matching-relation-with-to relation (cdr froms-list)))))

(defmethod get-to ((concept symbol) (relation-class t))
  "helper method to get a concept instance bound to a symbol"
  (get-to (symbol-value concept) relation-class))

(defmethod get-to ((concept t) (relation-class symbol))
  "helper method to get a relation class bound to a symbol"
  (get-to concept (find-class relation-class)))

;(print "defined get-to")

(defgeneric get-from (concept relation-class)
  (:documentation "get the concept in the from slot of any relation of type relation-class
   having the given concept in its to slot"))


(defmethod get-from ((concept Concept) (relation-class Standard-Class))
  "returns the concept in the from slot of a relation"
  (find-from-of-matching-relation relation-class (tos concept)))

(defun find-from-of-matching-relation (relation-class tos-list)
  "given a relation class and a list of relations, find a relation in that list that has a non-null from slot"
  (cond ((null tos-list) nil)
        ((and (eq (class-of (car tos-list)) relation-class)
              (from (car tos-list)))
         (from (car tos-list)))
        (t (find-matching-relation-with-to relation (cdr tos-list)))))


(defmethod get-from ((concept symbol) (relation-class t))
  "helper method to get a concept instance bound to a symbol"
  (get-from (symbol-value concept) relation-class))

(defmethod get-from ((concept t) (relation-class symbol))
  "helper method to get a relation class bound to a symbol"
  (get-from concept (find-class relation-class)))

;(print "defined get-from")

(defgeneric set-to (relation new-concept)
  (:documentation "set the to slot of the given relation to new-concept"))

(defmethod set-to ((relation Relation) (new-concept Concept))
  "sets the to slot of a relation to a new concept"
  (setf (to relation) new-concept))

(defmethod set-to ((relation symbol) (new-concept t))
  "helper method to get a relation instance bound to a symbol"
  (set-to (symbol-value relation) new-concept))

(defmethod set-to ((relation t) (new-concept symbol))
  "helper method to get a concept instance bound to a symbol"
  (set-to relation (symbol-value new-concept)))

;(print "defined set-to")

(defgeneric set-from (relation new-concept)
  (:documentation "set the from slot of the given relation to new-concept"))

(defmethod set-from ((relation Relation) (new-concept Concept))
  "sets the from slot of a relation to a new concept"
  (setf (from relation) new-concept))

(defmethod set-from ((relation symbol) (new-concept t))
  "helper method to get a relation instance bound to a symbol"
  (set-from (symbol-value relation) new-concept))

(defmethod set-from ((relation t) (new-concept symbol))
  "helper method to get a concept instance bound to a symbol"
  (set-from relation (symbol-value new-concept)))

;(print "defined set-from")

(defmethod (setf to) :before ((concept Concept) (relation Relation))
  "before method to delete a relation from the tos list of a concept the relation has in its to slot
  before the relation's to slot is set to another concept"
  ;(print "calling :before method for (setf to)")
  ;delete the relation from the tos slot of the concept in the current to slot in the relation
  (if (slot-boundp relation 'to)
      (setf (tos (to relation)) (delete relation (tos (to relation))))))

(defmethod (setf to) :after ((concept Concept) (relation Relation))
  "after method to add a relation to the tos slot list of a concept after the relation's to
  slot has been set to that concept"
  ;(print "calling :after method for (setf to)")
  (setf (tos concept) (cons relation (tos concept))))

(defmethod (setf from) :before ((concept Concept) (relation Relation) )
  "before method to delete a relation from the froms list of a concept the relation has in its from slot
  before the relation's from slot is set to another concept"
  ;(print "calling :before method for (setf from)")
  ;delete the relation from the froms slot of the concept in the current from slot in the relation
  (if (slot-boundp relation 'from)
      (setf (froms (from relation)) (delete relation (froms (from relation))))))

(defmethod (setf from) :after ((concept Concept) (relation Relation))
  "after method to add a relation to the froms slot list of a concept after the relation's from
  slot has been set to that concept"
  ;(print "calling :after method for (setf from)")
  (setf (froms concept) (cons relation (froms concept))))


(defun test-a4 ()
  (print "(define-concept Human) -> ")
  (print (define-concept Human))
  (print "human -> ")
  (print human)
  (print "(define-concept Dog) -> ")
  (print (define-concept Dog))
  (print "dog -> ")
  (print dog)
  (print "(define-relation Owns Human Dog) -> ")
  (print (define-relation Owns Human Dog))
  (print "(setq h1 (make-concept 'Human 'John)) -> ")
  (print (setq h1 (make-concept 'Human 'John)))
  (print "(name h1) -> ")
  (print (name h1))
  (print "(setq d1 (make-concept 'Dog 'Fido)) -> ")
  (print (setq d1 (make-concept 'Dog 'Fido)))
  (print "(name d1) -> ")
  (print (name d1))
  (print "(setq o1 (make-relation 'Owns 'owns1 :from h1 :to d1)) -> ")
  (print (setq o1 (make-relation 'Owns 'owns1 :from h1 :to d1)))
  (print "(from o1) -> ")
  (print (from o1))
  (print "(to o1) -> ")
  (print (to o1))
  (print "(froms h1) -> ")
  (print (froms h1))
  (print "(tos d1) -> ")
  (print (tos d1))
  (print "(setq h2 (make-concept 'Human 'Sue)) -> ")
  (print (setq h2 (make-concept 'Human 'Sue)))
  (print "(setf (from o1) h2) -> ")
  (print (setf (from o1) h2))
  (print "(from o1) -> ")
  (print (from o1))
  (print "(name (from o1)) -> ")
  (print (name (from o1)))
  (print "(froms h1) -> ")
  (print (froms h1))
  (print "(froms h2) -> ")
  (print (froms h2))
  (print "(setq d2 (make-concept 'Dog 'Lassie)) -> ")
  (print (setq d2 (make-concept 'Dog 'Lassie)))
  (print "(setf (to o1) d2) -> ")
  (print (setf (to o1) d2))
  (print "(to o1) -> ")
  (print (to o1))
  (print "(name (to o1)) -> ")
  (print (name (to o1)))
  (print "(tos d1) -> ")
  (print (tos d1))
  (print "(tos d2) -> ")
  (print (tos d2))
  "done"
  )

;(test-a4)

