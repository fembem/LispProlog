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

(defclass Concept (Node)
  ((froms :type list :accessor froms :initarg :froms :initform nil
          :documentation "a list of the Relations whose from slot is this Concept")
   (tos :type list :accessor tos :initarg :tos :initform nil
        :documentation "a list of the Relations whose to slot is this Concept"))
  (:documentation "An physical or conceptual object"))

(defclass Relation (Node)
  ((from :type Concept :accessor from :initarg :from
         :documentation "the Concept that this Relation is from")
   (to :type Concept :accessor to :initarg :to
       :documentation "the Concept that this Relation is to"))
  (:documentation "A relationship between two Concepts"))

(defun make-concept (class &optional name)
  (make-instance class :name name))

(defun make-relation (class &optional name &key from to)
  (make-instance class :name name :from from :to to))

(defmacro define-concept (class-name)
  `(setq ,class-name (defclass ,class-name (Concept) () )))

(defmacro define-relation (class-name from-concept to-concept)
  `(setq ,class-name (defclass ,class-name (Relation) ((from :type ,from-concept) (to :type ,to-concept)) )))

(defmethod get-to ((concept Concept) (relation-class Relation))
  (to relation-class))

(defmethod get-to ((concept 'symbol) (relation-class Relation))
  (get-to (find-class concept) relation-class))

(defmethod get-to ((concept 'symbol) (relation-class 'symbol))
  (get-to (find-class concept) (find-class relation-class)))

(defmethod get-to ((concept Concept) (relation-class 'symbol))
  (get-to concept (find-class relation-class)))


(defun get-from (concept relation-class)
  (from relation-class))

(defun set-to (relation new-concept)
  (setf (to relation) new-concept))

(defun set-from (relation new-concept)
  (setf (from relation) new-concept))

