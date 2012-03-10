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



(defclass Node ()
  ((name :accessor name :initarg :name :type 'symbol
         :documentation "the name of the Concept or Relation"))
  (:documentation "The top level class, subclasses include Concepts and Relations"))

(print "defined Node")

(defclass Concept (Node)
  ((froms :type list :accessor froms :initarg :froms :initform nil
          :documentation "a list of the Relations whose from slot is this Concept")
   (tos :type list :accessor tos :initarg :tos :initform nil
        :documentation "a list of the Relations whose to slot is this Concept"))
  (:documentation "An physical or conceptual object"))

(print "defined Concept")

(defclass Relation (Node)
  ((from :type Concept :accessor from :initarg :from
         :documentation "the Concept that this Relation is from")
   (to :type Concept :accessor to :initarg :to
       :documentation "the Concept that this Relation is to"))
  (:documentation "A relationship between two Concepts"))

(defun make-concept (class &optional name)
  (make-instance class :name name))

(print "defined make-concept")

(defun make-relation (class &optional name &key from to)
  (make-instance class :name name :from from :to to))

(print "defined make-relation")

(defmacro define-concept (class-name)
  `(setq ,class-name (defclass ,class-name (Concept) () )))

(print "defined define-concept")

(defmacro define-relation (class-name from-concept to-concept)
  `(setq ,class-name (defclass ,class-name (Relation) ((from :type ,from-concept) (to :type ,to-concept)) )))

(print "defined define-relation")

(defmethod get-to ((concept Concept) (relation-class Relation))
  (to relation-class))

(defmethod get-to ((concept symbol) (relation-class t))
  (get-to (find-class concept) relation-class))

(defmethod get-to ((concept t) (relation-class symbol))
  (get-to concept (find-class relation-class)))

(print "defined get-to")

(defmethod get-from ((concept Concept) (relation-class Relation))
  (from relation-class))

(defmethod get-from ((concept symbol) (relation-class t))
  (get-from (find-class concept) relation-class))

(defmethod get-from ((concept t) (relation-class symbol))
  (get-from concept (find-class relation-class)))

(print "defined get-from")

(defmethod set-to ((relation Relation) (new-concept Concept))
  (to relation-class))

(defmethod set-to ((relation symbol) (new-concept t))
  (set-to (find-class concept) relation-class))

(defmethod set-to ((relation t) (new-concept symbol))
  (set-to concept (find-class relation-class)))

(print "defined set-to")


(defmethod set-from ((relation Relation) (new-concept Concept))
  (from relation-class))

(defmethod set-from ((relation symbol) (new-concept t))
  (set-from (find-class concept) relation-class))

(defmethod set-from ((relation t) (new-concept symbol))
  (set-from concept (find-class relation-class)))

(print "defined set-from")
