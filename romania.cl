
         
(defconstant *adjancies*      
      '(
        (Arad . (Sibiu Zerind Timisoara))
        (Bucharest . (Giurgiu Pitesti Fagaras Urziceni))
        (Craoiva . (Dobreca Rimnicu Pitesti))
        (Dobreta . (Craoiva Mehadia))
        (Eforie . (Hirsova))
        (Fagaras . (Sibiu Bucharest))
        (Giurgiu . (Bucharest))
        (Hirsova . (Urziceni Eforie))
        (Iasi . (Neamt Vaslui))
        (Lugoj . (Timisoara Mehadia))
        (Mehadia . (Lugoj Dobreta))
        (Neamt . (Iasi))
        (Oradea . (Zerind Sibiu))
        (Pitesti . (Rimnicu Craoiva))
        (Rimnicu . (Pitesti Sibiu Craoiva))
        (Sibiu . (Arad Oradea Fagaras Rimnicu))
        (Timisoara . (Arad Lugoj))
        (Urziceni . (Bucharest Hirsova Vaslui))
        (Vaslui . (Urziceni Iasi))
        (Zerind . (Arad Oradea))

        ))

         
(defconstant *cost-list*
      '(
        ((Arad . Sibiu) . 140)
        ((Arad . Zerind) . 75)
        ((Arad . Timisoara) . 118)
        ((Oradea . Zerind) . 71)
        ((Oradea . Sibiu) . 151)
        ((Timisoara . Lugoj) . 111)
        ((Lugoj . Mehadia) . 70)
        ((Mehadia . Dobreta) . 75)
        ((Dobreta . Craoiva) . 120)
        ((Craoiva . Pitesti) . 138)
        ((Craiova . Rimnicu) . 146)
        ((Rimnicu . Sibiu) . 80)
        ((Fagaras . Sibiu) . 99)
        ((Fagaras . Bucharest) . 211)
        ((Rimnicu . Pitesti) . 97)
        ((Pitesti . Bucharest) . 101)
        ((Bucharest . Giurgiu) . 90)
        ((Bucharest . Urziceni) . 85)
        ((Urziceni . Hirsova) . 98)
        ((Hirsova . Eforie) . 86)
        ((Urziceni . Vaslui) . 142)
        ((Vaslui . Iasi) . 92)
        ((Iasi . Neamt) . 87)
        
        ))

(defconstant *distance-to-Bucharest*
      '(
        (Arad . 366)
        (Bucharest . 0)
        (Craoiva . 160)
        (Dobreta . 242)
        (Eforie . 161)
        (Fagaras . 178)
        (Giurgiu . 77)
        (Hirsova . 151)
        (Iasi . 226)
        (Lugoj . 244)
        (Mehadia . 241)
        (Neamt . 234)
        (Oradea . 380)
        (Pitesti . 98)
        (Rimnicu . 193)
        (Sibiu . 253)
        (Timisoara . 329)
        (Urziceni . 80)
        (Vaslui . 199)
        (Zerind . 374)

        ))

(defun cost-from-to (from to)
  (cond ((setq result (assoc (cons from to) *cost-list* :test #'equal)) (cdr result))
        ((setq result (assoc (cons to from) *cost-list* :test #'equal)) (cdr result))
        (t 
         (format t "no cost info for ~A -> ~A~%" from to)
         'fail)))

(defun get-dest0 (from)
  (let ((adj-list (adjacents from)))
    (cond (
           ((>=(length adj-list) 0)
            (cost-from-to from (nth 0 (adjacents from))))
           (t nil)))))

(defun get-dest1 (from)
  (let ((adj-list (adjacents from)))
    (cond (
           ((>=(length adj-list) 1)
            (cost-from-to from (nth 0 (adjacents from))))
           (t nil)))))

(defun get-dest2 (from)
  (let ((adj-list (adjacents from)))
    (cond (
           ((>=(length adj-list) 2)
            (cost-from-to from (nth 0 (adjacents from))))
           (t nil)))))


(defun get-dest3 (from)
  (let ((adj-list (adjacents from)))
    (cond (
           ((>=(length adj-list) 3)
            (cost-from-to from (nth 0 (adjacents from))))
           (t nil)))))

(defun get-move-functions ()
  (list #'get-dest0 #'get-dest1 #'get-dest2 #'get-dest3))

(setq *moves* (get-move-functions))


(defun heuristic (state)
  (cdr (assoc state *distance-to-Bucharest* :test #'equal)))

(defun adjacents (state)
  (cdr (assoc state *adjancies* :test #'equal)))
