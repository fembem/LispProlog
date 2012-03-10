;;; This is the IDE's built-in-editor, where you create and edit
;;; lisp source code.  You could use some other editor instead,
;;; though the IDE's menu-bar commands would not be applicable there.
;;; 
;;; This editor has a tab for each file that it's editing.  You can
;;; create a new editor buffer at any time with the File | New command.
;;; Other commands such as Search | Find Definitions will create
;;; editor buffers automatically for existing code.
;;; 
;;; You can use the File | Compile and Load command to compile and
;;; load an entire file, or compile an individual definition by
;;; placing the text cursor inside it and using Tools | Incremental
;;; Compile.  You can similarly evaluate test expressions in the
;;; editor by using Tools | Incremental Evaluation; the returned
;;; values and any printed output will appear in a lisp listener
;;; in the Debug Window.
;;; 
;;; For a brief introduction to other IDE tools, try the
;;; Help | Interactive IDE Intro command.  And be sure to explore
;;; the other facilities on the Help menu.

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
    (if from (setf (froms from) (cons instance (froms from))))
    (if to (setf (tos to) (cons instance (tos to))))
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

(defmethod get-to ((concept Concept) (relation-class Relation))
  "returns the concept in the to slot of a relation"
  (to relation-class))

(defmethod get-to ((concept symbol) (relation-class t))
  "helper method to get a concept instance bound to a symbol"
  (get-to (find-class concept) relation-class))

(defmethod get-to ((concept t) (relation-class symbol))
  "helper method to get a relation class bound to a symbol"
  (get-to concept (find-class relation-class)))

;(print "defined get-to")

(defmethod get-from ((concept Concept) (relation-class Relation))
  "returns the concept in the from slot of a relation"
  (from relation-class))

(defmethod get-from ((concept symbol) (relation-class t))
  "helper method to get a concept instance bound to a symbol"
  (get-from (find-class concept) relation-class))

(defmethod get-from ((concept t) (relation-class symbol))
  "helper method to get a relation class bound to a symbol"
  (get-from concept (find-class relation-class)))

;(print "defined get-from")

(defmethod set-to ((relation Relation) (new-concept Concept))
  "sets the to slot of a relation to a new concept"
  (setf (to relation) new-concept))

(defmethod set-to ((relation symbol) (new-concept t))
  "helper method to get a relation instance bound to a symbol"
  (set-to (find-class relation) new-concept))

(defmethod set-to ((relation t) (new-concept symbol))
  "helper method to get a concept instance bound to a symbol"
  (set-to relation (find-class new-concept)))

;(print "defined set-to")


(defmethod set-from ((relation Relation) (new-concept Concept))
  "sets the from slot of a relation to a new concept"
  (setf (from relation) new-concept))

(defmethod set-from ((relation symbol) (new-concept t))
  "helper method to get a relation instance bound to a symbol"
  (set-from (find-class relation) new-concept))

(defmethod set-from ((relation t) (new-concept symbol))
  "helper method to get a concept instance bound to a symbol"
  (set-from relation (find-class new-concept)))

;(print "defined set-from")

(defmethod (setf to) :before ((relation Relation) (concept Concept))
  "before method to delete a relation from the tos list of a concept the relation has in its to slot
  before the relation's to slot is set to another concept"
  (delete relation (tos concept)))

(defmethod (setf to) :after ((relation Relation) (concept Concept))
  "after method to add a relation to the tos slot list of a concept after the relation's to
  slot has been set to that concept"
  (setf (tos concept) (cons relation (tos concept))))

(defmethod (setf from) :before ((relation Relation) (concept Concept))
  "before method to delete a relation from the froms list of a concept the relation has in its from slot
  before the relation's from slot is set to another concept"
  (delete relation (froms concept)))

(defmethod (setf from) :after ((relation Relation) (concept Concept))
  "after method to add a relation to the froms slot list of a concept after the relation's from
  slot has been set to that concept"
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

(test-a4)

