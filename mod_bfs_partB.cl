;;;Leo deCandia
;;;ICS 361
;;;Assignment 3 part B
;;;modification of code in textbook


;;; This is one of the example programs from the textbook:
;;;
;;; Artificial Intelligence: 
;;; Structures and strategies for complex problem solving
;;;
;;; by George F. Luger and William A. Stubblefield
;;;
;;; Corrections by Christopher E. Davis (chris2d@cs.unm.edu)
;;; 
;;;
;;; These programs are copyrighted by Benjamin/Cummings Publishers.
;;;
;;; We offer them for use, free of charge, for educational purposes only.
;;;
;;; Disclaimer: These programs are provided with no warranty whatsoever as to
;;; their correctness, reliability, or any other property.  We have written 
;;; them for specific educational purposes, and have made no effort
;;; to produce commercial quality computer programs.  Please do not expect 
;;; more of them then we have intended.
;;;
;;; This code has been tested with CMU Common Lisp CVS release-19a
;;; 19a-release-20040728 and appears to function as intended.

;;; this file contains the best-first search algorithm from chapter 7.

;;; for a simple example of its use with the farmer wolf goat and cabbage rules, 
;;; evaluate the move rule definitions in farmer_wolf_etc_rules_only.lisp,
;;; and bind them to the gloabl variable, *moves*:

; (setq *moves* 
;      '(farmer-takes-self farmer-takes-wolf 
;       farmer-takes-goat farmer-takes-cabbage))

;;; Also, the algorithm requires that a simple heuristic be used to evaluate
;;; states.  For the farmer, wolf, goat and cabbage rules, a simple heuristic 
;;; counts the number of players not in their goal positions:

; (defun heuristic (state)
;  (declare (special *goal*))
;  (heuristic-eval state *goal*))

; (defun heuristic-eval (state goal)
;  (cond ((null state) 0)
;        ((equal (car state) (car goal)) 
;        (heuristic-eval (cdr state) (cdr goal)))
;        (t (1+ (heuristic-eval (cdr state) (cdr goal))))))
;
;;; Once these have been defined, evaluate:
;;;
;;;  (run-best '(e e e e) '(w w w w))





;;; insert-by-weight will add new child states to an ordered list of 
;;; states-to-try.  
(defun insert-by-weight (children sorted-list)
  (cond ((null children) sorted-list)
        (t (insert (car children) 
           (insert-by-weight (cdr children) sorted-list)))))

(defun insert (item sorted-list)
  (cond ((null sorted-list) (list item))
        ((< (get-weight item) (get-weight (car sorted-list)))
         (cons item sorted-list))
        (t (cons (car sorted-list) (insert item (cdr sorted-list))))))


;;; run-best is a simple top-level "calling" function to run best-first-search

(defun run-best (start goal)
  (declare (special *goal*)
           (special *open*)
           (special *closed*))
  (setq *goal* goal)
  (setq *open* (list (build-record start nil 0 (heuristic start))))
  (setq *closed* nil)
  (best-first))

;;; These functions handle the creation and access of (state parent) 
;;; pairs.

(defun build-record (state parent depth weight) 
  (list state parent depth weight))

(defun get-state (state-tuple) (nth 0 state-tuple))

(defun get-parent (state-tuple) (nth 1 state-tuple))

(defun get-depth (state-tuple) (nth 2 state-tuple))

(defun get-weight (state-tuple) (nth 3 state-tuple))

(defun retrieve-by-state (state list)
  (cond ((null list) nil)
        ((equal state (get-state (car list))) (car list))
        (t (retrieve-by-state state (cdr list)))))


;; best-first defines the actual best-first search algorithm
;;; it uses "global" open and closed lists.

(defun best-first ()
  (declare (special *goal*)
           (special *open*)
           (special *closed*)
           (special *moves*))
  (format t "~%open   = ~A~%" *open*) 
  (format t   "closed = ~A~%" *closed*)
  (cond ((null *open*) nil)
        (t (let ((state (car *open*)))
             (setq *closed* (cons state *closed*))
             (cond ((equal (get-state state) *goal*) (reverse (build-solution *goal*)))
                   (t (setq *open* 
                            (insert-by-weight 
                                    (generate-descendants (get-state state)
                                                          (get-depth state)
                                                          *moves*)
                                    (cdr *open*)))
                      (best-first)))))))


;;; generate-descendants produces all the descendants of a state

(defun generate-descendants (state depth-of-parent moves)
  (declare (special *closed*)
           (special *open*))
  (cond ((null moves) nil)
        (t (let ((child (funcall (car moves) state))
                 (rest (generate-descendants state depth-of-parent (cdr moves))))
             (cond ((null child) rest)
                   ((retrieve-by-state child rest) rest)
                   ((setq the-state (retrieve-by-state child *open*)) 
                    (delete-from-list-if-necessary the-state state *open* 
                                                   (+ depth-of-parent (cost-from-to state child))) 
                    rest)
                   ((setq the-state (retrieve-by-state child *closed*)) 
                    (delete-from-list-if-necessary the-state state *closed* 
                                                   (+ depth-of-parent (cost-from-to state child))) 
                    rest)
                   (t (cons (build-record child state (+ depth-of-parent (cost-from-to state child)) 
                                          (+ (+ depth-of-parent (cost-from-to state child)) (heuristic child))) 
                            rest)))))))

(defun delete-from-list-if-necessary (state parent list depth)
  (if (< depth (get-depth state)) 
      (progn
        (format t "****found new route to ~A from ~A with cost ~A " (get-state state) parent depth )
        (format t "instead of from ~A with cost ~A****~%" (get-parent state) (get-depth state))
        (delete-state-from-list state list)
      )
    ))

(defun delete-state-from-list (state list)
  (setq list (delete state list)))

(defun build-solution (state)
  (declare (special *closed*))
  (cond ((null state) nil)
        (t (cons state (build-solution 
                        (get-parent 
                         (retrieve-by-state state *closed*)))))))

