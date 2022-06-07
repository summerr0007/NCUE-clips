(deftemplate edge (slot v1)(slot v2)(slot distance))
(deftemplate shortest (slot v1)(slot v2)(slot distance))
(deftemplate path (slot v1)(slot v2)(slot distance)(slot left)(multislot route))
(deffacts initial
  (vertex A)
  (vertex B)
  (vertex C)
  (vertex D)
  (vertex E)
  (vertex F)
  (vertex G)
  (vertex H)
  (vertex I)
  (vertex J)
  (edge (v1 A) (v2 B) (distance 8))
  (edge (v1 A) (v2 C) (distance 3))
  (edge (v1 A) (v2 D) (distance 12))
  (edge (v1 B) (v2 D) (distance 23))
  (edge (v1 B) (v2 E) (distance 19))
  (edge (v1 C) (v2 D) (distance 5))
  (edge (v1 C) (v2 F) (distance 39))
  (edge (v1 D) (v2 E) (distance 2))
  (edge (v1 D) (v2 F) (distance 32))
  (edge (v1 D) (v2 G) (distance 16))
  (edge (v1 E) (v2 G) (distance 7))
  (edge (v1 F) (v2 G) (distance 19))
  (edge (v1 F) (v2 H) (distance 17))
  (edge (v1 F) (v2 I) (distance 6))
  (edge (v1 G) (v2 I) (distance 11))
  (edge (v1 G) (v2 J) (distance 2))
  (edge (v1 H) (v2 I) (distance 25))
  (edge (v1 I) (v2 J) (distance 10))
)

(defrule generate-anti-direction-edge
	(declare (salience 90))
	(edge (v1 ?v1)(v2 ?v2)(distance ?d))
	(not (edge (v1 ?v2)(v2 ?v1)(distance ?d)))
	=>
	(assert (edge (v1 ?v2)(v2 ?v1)(distance ?d)))
	(assert (shortest (v1 ?v1)(v2 ?v2)(distance ?d)))
	(assert (shortest (v1 ?v2)(v2 ?v1)(distance ?d))))

(defrule generate-disconnected-distance
	(declare (salience 80))
	(vertex ?v1)
	(vertex ?v2&~?v1)
	(not (edge (v1 ?v1)(v2 ?v2)(distance ?)))
	=>
	(assert (shortest (v1 ?v1)(v2 ?v2)(distance 1000))))

(defrule input-vertex
	(declare (salience 100))
	=>
	(printout t "Start Vertex: ")
	(assert (start (read)))
	(printout t "End Vertex: ")
	(assert (end (read))))

(defrule generate-path
	(start ?s)
	(end ?e)
	(shortest (v1 ?s)(v2 ?e)(distance ?d))
	=>
	(assert (path (v1 ?s)(v2 ?e)(distance ?d)(left ?d)(route ?s))))


(defrule min-distance
	(declare (salience 70))
	?f1<-(shortest (v1 ?v1)(v2 ?v2)(distance ?x))
	(shortest (v1 ?v1)(v2 ?v3)(distance ?y))
	(edge (v1 ?v3)(v2 ?v2)(distance ?z))
	(test (< (+ ?y ?z) ?x))
	=>
	(retract ?f1)
	(assert (shortest (v1 ?v1)(v2 ?v2)(distance (+ ?y ?z)))))

(defrule min-route
	(declare (salience 60))
	(path (v1 ?s)(v2 ?e)(distance ?d)(left ?l)(route $?front ?traget))
	(edge (v1 ?traget)(v2 ?v2)(distance ?x))
	(test (< 0 (- ?l ?x)))
	(test (not (member$ ?v2 $?front)))
	=>
	(assert (path (v1 ?s)(v2 ?e)(distance ?d)(left (- ?l ?x))(route $?front ?traget ?v2))))

(defrule find-ans
	(declare (salience 50))
	(path (v1 ?s)(v2 ?e)(distance ?d)(left ?l)(route $?front ?traget))
	(edge (v1 ?traget)(v2 ?e)(distance ?x))
	(test (= ?x ?l))
	=>
	(assert (path (v1 ?s)(v2 ?e)(distance ?d)(left 0)(route $?front ?traget ?e))))


(defrule printout
	(declare (salience 40))
	(path (v1 ?s)(v2 ?e)(distance ?d)(left ?l&0)(route $?route))
	=>
	(printout t "Distance: " ?d "Route: " $?route crlf))














	