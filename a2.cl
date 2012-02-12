(defun make-state (p1 p2 p3 p4 p5 p6 p7 p8 p9)
  (list p1 p2 p3 p4 p5 p6 p7 p8 p9))

(defun clone-state (state)
  (copy-list state))

(defun print-state (state)
  (format t "~A ~A ~A~%" (nth 0 state) (nth 1 state) (nth 2 state))
  (format t "~A ~A ~A~%" (nth 3 state) (nth 4 state) (nth 5 state))
  (format t "~A ~A ~A~%" (nth 6 state) (nth 7 state) (nth 8 state)))
 

(setq *goal* (make-state 1 2 3 8 0 4 7 6 5))

(defun blank-row-column (state)
  (let* ((pos-0 (position 0 state))
         (col (mod pos-0 3))
         (row (floor (/ pos-0 3))))
    (list row col)))

(defun blank-row (state)
  (first (row-column state)))

(defun blank-column (state)
  (second (row-column state)))

(defun list-pos (row column state)
  (+ (* row 3) column))

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
  (cond ((eq (blank-row state) 0) nil)
        (t (let* (
                  (new-state (clone-state state))
                  (row (blank-row state))
                  (column (blank-column state))
                  )
             (setf (elt-at row column new-state) (elt-above row column state))
             (setf (elt-above row column new-state) (elt-above row column state))
             (new-state)))))


