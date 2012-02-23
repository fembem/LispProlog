;Leo deCandia
;ICS 361
;Assignment 2
;due 2/16/12
;reused for Assignment 3


(defun make-state (p1 p2 p3 p4 p5 p6 p7 p8 p9)
  (list p1 p2 p3 p4 p5 p6 p7 p8 p9))

(defun clone-state (state)
  (copy-list state))

(defun print-state (state)
  (format t "~A ~A ~A~%" (nth 0 state) (nth 1 state) (nth 2 state))
  (format t "~A ~A ~A~%" (nth 3 state) (nth 4 state) (nth 5 state))
  (format t "~A ~A ~A~%" (nth 6 state) (nth 7 state) (nth 8 state)))
 

(defconstant *goal* (make-state 1 2 3 8 0 4 7 6 5))

(defconstant *numbers* '(1 2 3 4 5 6 7 8))

(defun row-column (number state)
  (let* ((pos-0 (position number state))
         (col (mod pos-0 3))
         (row (floor (/ pos-0 3))))
    (list row col)))

(defun blank-row-column (state)
  (row-column 0 state))

(defun row-of (number state)
  (first (row-column number state)))

(defun column-of (number state)
  (second (row-column number state)))

(defun blank-row (state)
  (first (blank-row-column state)))

(defun blank-column (state)
  (second (blank-row-column state)))

(defun list-pos (row column state)
  (cond ((or (< row 0) (> row 2) (< column 0) (> column 2)) 'no-such-position)
        (t (+ (* row 3) column))))

(defun elt-at (row column state)
  (nth (list-pos row column state) state))

(defun elt-above (row column state)
  (nth (list-pos (- row 1) column state) state))

(defun elt-below (row column state)
  (nth (list-pos (+ row 1) column state ) state))

(defun elt-to-right (row column state)
  (nth (list-pos row (+ column 1) state) state))

(defun elt-to-left (row column state)
  (nth (list-pos row (- column 1) state) state))

(defun move-blank-up (state)
  "move blank up"
  ;(format t "in move-blank-up")
  (cond ((eq (blank-row state) 0) nil)
        (t (let* (
                  (new-state (clone-state state))
                  (row (blank-row state))
                  (column (blank-column state))
                  )
             ;(setf (elt-at row column new-state) (elt-above row column state))
             (setf (nth (list-pos row column new-state) new-state) (nth (list-pos (- row 1) column state) state))
             ;(setf (elt-above row column new-state) (elt-above row column state))
             (setf (nth (list-pos (- row 1) column new-state) new-state) (nth (list-pos row column state) state))
             (copy-list new-state)))))

(defun move-blank-down (state)
  "move blank down"
  ;(format t "in move-blank-down")
  (cond ((eq (blank-row state) 2) nil)
        (t (let* (
                  (new-state (clone-state state))
                  (row (blank-row state))
                  (column (blank-column state))
                  )
             (setf (nth (list-pos row column new-state) new-state) (nth (list-pos (+ row 1) column state) state))
             (setf (nth (list-pos (+ row 1) column new-state) new-state) (nth (list-pos row column state) state))
             (copy-list new-state)))))

(defun move-blank-left (state)
  "move blank left"
  ;(format t "in move-blank-left")
  (cond ((eq (blank-column state) 0) nil)
        (t (let* (
                  (new-state (clone-state state))
                  (row (blank-row state))
                  (column (blank-column state))
                  )
             (setf (nth (list-pos row column new-state) new-state) (nth (list-pos row (- column 1) state) state))
             (setf (nth (list-pos row (- column 1) new-state) new-state) (nth (list-pos row column state) state))
             (copy-list new-state)))))

(defun move-blank-right (state)
  "move blank right"
  ;(format t "in move-blank-right")
  (cond ((eq (blank-column state) 2) nil)
        (t (let* (
                  (new-state (clone-state state))
                  (row (blank-row state))
                  (column (blank-column state))
                  )
             (setf (nth (list-pos row column new-state) new-state) (nth (list-pos row (+ column 1) state) state))
             (setf (nth (list-pos row (+ column 1) new-state) new-state) (nth (list-pos row column state) state))
             (copy-list new-state)))))

(defun manhat-dist-of (number state1 state2)
  (let* (
         (row1 (row-of number state1))
         (col1 (column-of number state1))
         (row2 (row-of number state2))
         (col2 (column-of number state2))
         (distx (abs (- row1 row2)))
         (disty (abs (- col1 col2)))
         )
    (+ distx disty)))

(defun make-manhat-dist-func (state1 state2)
  #'(lambda (number) (manhat-dist-of number state1 state2)))

(defun manhat-dist (state1 state2)
  (apply '+ (mapcar (make-manhat-dist-func state1 state2) *numbers*)))

(setq *moves* 
     '(move-blank-up move-blank-down 
      move-blank-left move-blank-right))

(defun heuristic (state)
  (manhat-dist state *goal*))


