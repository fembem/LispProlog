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
  (cond ((not (listp pred-1)) 'fail)
        ((not (listp pred-2)) 'fail)
        ((not (eq (length pred-1) (length pred-2))) 'fail)
        ((eq 0 (length pred-1)) nil)
        ((eq 'fail (match (cdr pred-1) (cdr pred-2))) 'fail)
        ((is-variable (car pred-1)) 
         (cons (list (car pred-1) (car pred-2)) (match (cdr pred-1) (cdr pred-2))))
        ((not (eq (car pred-1) (car pred-2))) 'fail)
        (t (match (cdr pred-1) (cdr pred-2)))))

(defun tree-replace (tree bindings)
  (cond ((null bindings) tree)
        (t (tree-replace (subst (second (car bindings)) (first (car bindings)) tree) (cdr bindings)))))

(defun match-all (pred db)
  (cond ((null db) nil)
        (t (let ((result (match pred (car db))))
             (cond ((eq result 'fail) (match-all pred (cdr db)))
                   (t (cons result (match-all pred (cdr db)))))))))

