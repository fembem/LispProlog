;Leo deCandia
;ICS 361
;Assignment 1
;due 2/5/12


(defconstant *db* 
    '((has-child father me)
     (married me wife)
     (has-child wife daughter)
     (married father daughter)))

(defun is-variable (a_symbol)
  (cond
   ((member a_symbol '(x y z)) t)
   (t NIL)))

(defun match-simple(pred-1 pred-2)
  (cond ((not (listp pred-1)) 'fail)
        ((not (listp pred-2)) 'fail)
        ((not (eq (length pred-1) (length pred-2))) 'fail)
        ((eq 0 (length pred-1)) nil)
        ((not (eq (car pred-1) (car pred-2))) 'fail)
        (t (match-simple (cdr pred-1) (cdr pred-2)))))

(defun match (pred-1 pred-2)
  ;matches pred-1 and pred-2 by checking that each of their elements matches
  ;and returns a list of binding tuples, one tuple for each variable bound
  (cond ((not (listp pred-1)) 'fail)  ;fail if pred-1 is not a list
        ((not (listp pred-2)) 'fail)  ;fail if pred-2 is not a list
        ((not (eq (length pred-1) (length pred-2))) 'fail)  ;fail is pred-1 and pred-2 have different lengths
        ((eq 0 (length pred-1)) nil)  ;return nil if pred-1 has length 0
        ((let ((match-result (match (cdr pred-1) (cdr pred-2))))  ;find the match of the cdr's of each list
           (cond ((eq 'fail match-result) 'fail)  ;if the result is failure, return failure
                 ((is-variable (car pred-1))   ;if the first element of pred-1 is a variable
                  (cons (list (car pred-1) (car pred-2)) match-result))  ;then create a binding tuple with it and the
                                                                         ;car of pred-2 and cons that binding tuple to
                                                                         ;the tuples returned for the rest of the match
                  
                 ((not (eq (car pred-1) (car pred-2))) 'fail)   ;if the elements don't match, then fail
                 (t (match (cdr pred-1) (cdr pred-2))))))))     ;if they do, there is no tuple binding, so just return
                                                                ;the tuples for the rest of the match

(defun tree-replace (tree bindings)
  (cond ((null bindings) tree)
        (t (tree-replace (subst (second (car bindings)) (first (car bindings)) tree) (cdr bindings)))))

(defun match-all (pred db)
  (cond ((null db) nil)
        (t (let ((result (match pred (car db))))
             (cond ((eq result 'fail) (match-all pred (cdr db)))
                   (t (cons result (match-all pred (cdr db)))))))))

(defun infer (inference db)
  ;returns a list of realized consequents from the db using the ineference
  ;does this by matching the first antecedent to the db, then branching on the possible bindings
  ;by doing infernce on each of the possible bindings with the old inference with its first antecedent removed
  ;if the antecedents list is empty, return the consequents
  (cond ((null (car inference)) (second inference))
        ;otherwise
        (t
         (let* ((antecedents (car inference))  ;the antecedent list is the car of the inference
                (pred (car antecedents))       ;the first predicate is the car of the antecedents list
                (remaining-antecedents (cdr antecedents))   ;after binding on the first antecddent, we only
                                                            ;care about the remaining ones
                (consequents (second inference))               ; the consequent list is the second element of the inference
                (sub-inference (list remaining-antecedents consequents))  ;the sub-inference consists of
                                                                          ;all but the first antecdent and the consequents
                (binding-sets (match-all pred db)))   ;the possible binding sets for the first antecedent (a list)
           (get-results sub-inference binding-sets db)))))

(defun get-results (inference binding-sets db)
  ;returns a list of consequents by calling infer for each of the sets in binding-sets
  ;if the binding-sets list is empty, it means the previous match-all failed
  ;and there are no results to return
  (cond ((null binding-sets) nil)
        ;get the inference with any bound variables replaced using the first choice in the binding-sets
        (t (let* ((inference-with-bindings (tree-replace inference (car binding-sets)))
                  ;do inference on this new inference and get a list of realized consequents
                  (consequents (infer inference-with-bindings db)))
             ;append this list of realized consequents to the other results
             (append consequents (get-results inference (cdr binding-sets) db))))))



