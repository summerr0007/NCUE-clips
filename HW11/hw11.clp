(defmodule MAIN (export deftemplate ?ALL))
(deftemplate MAIN::cell(slot row)(slot column)(slot status))
(deftemplate MAIN::dimensions(slot rows)(slot columns))
(defrule MAIN::life-init
    (last-generation ?l)
    ?f<-(current-generation ?c&:(<= ?c ?l))
    =>
    (retract ?f)
    (assert(current-generation(+ ?c 1)))
    (focus PRINT COMPUTE-NEIGHBORS NEXT-GENERATION)
)


(defmodule PRINT (import MAIN deftemplate ?ALL))

(defmodule COMPUTE-NEIGHBORS (import MAIN deftemplate cell)(export deftemplate neighbor-sum))

(deftemplate COMPUTE-NEIGHBORS::neighbor (slot row)(slot column)(multislot live-cell))

(deftemplate COMPUTE-NEIGHBORS::neighbor-sum (slot row)(slot column)(slot value))

(defmodule NEXT-GENERATION (import MAIN deftemplate cell)(import COMPUTE-NEIGHBORS deftemplate neighbor-sum))

(deffacts MAIN::initial
 
  (cell (row 1) (column 1) (status -))
  (cell (row 1) (column 2) (status *))
  (cell (row 1) (column 3) (status -))
  (cell (row 1) (column 4) (status -))
  (cell (row 1) (column 5) (status *))

  (cell (row 2) (column 1) (status -))
  (cell (row 2) (column 2) (status *))
  (cell (row 2) (column 3) (status *))
  (cell (row 2) (column 4) (status *))
  (cell (row 2) (column 5) (status *))

  (cell (row 3) (column 1) (status -))
  (cell (row 3) (column 2) (status *))
  (cell (row 3) (column 3) (status -))
  (cell (row 3) (column 4) (status -))
  (cell (row 3) (column 5) (status *))

  (cell (row 4) (column 1) (status -))
  (cell (row 4) (column 2) (status -))
  (cell (row 4) (column 3) (status -))
  (cell (row 4) (column 4) (status *))
  (cell (row 4) (column 5) (status -))

  (cell (row 5) (column 1) (status -))
  (cell (row 5) (column 2) (status -))
  (cell (row 5) (column 3) (status -))
  (cell (row 5) (column 4) (status -))
  (cell (row 5) (column 5) (status -))

  (dimensions (rows 5) (columns 5))
  (current-generation 0)
  (last-generation 4)
)



(defrule PRINT::start-print
    (current-generation ?g)
    =>
    (assert (print-row 1))
    (assert (print-column 1))
    (printout t crlf "Generation "?g crlf)
)

(defrule PRINT::cell-print
    (dimensions (rows ?nr)(columns ?nc))
    ?f <- (print-column ?c&:(<= ?c ?nc))
    (print-row ?r&:(<= ?r ?nr))
    (cell (row ?r)(column ?c)(status ?s))
    =>
    (printout t ?s)
    (retract ?f)
    (assert (print-column(+ 1 ?c)))
)

(defrule PRINT::reset-column
    (declare(salience -10))
    (dimensions (rows ?nr)(columns ?nc))
    ?f <- (print-column ?c&:(> ?c ?nc))
    ?p <-(print-row ?r&:(< ?r ?nr))
    =>
    (retract ?f ?p)
    (assert (print-column 1))
    (assert (print-row(+ 1 ?r)))
    (printout t crlf)
)

(defrule COMPUTE-NEIGHBORS::make-neighbors
    (cell(row ?x)(column ?y)(status *))
    =>
    (assert (neighbor (row (- ?x 1)) (column(- ?y 1)) (live-cell ?x ?y)))
    (assert (neighbor (row (- ?x 1)) (column ?y) (live-cell ?x ?y) ))
    (assert (neighbor (row (- ?x 1)) (column(+ ?y 1)) (live-cell ?x ?y)))
    (assert (neighbor (row ?x) (column(- ?y 1)) (live-cell ?x ?y)))
    (assert (neighbor (row ?x) (column(+ ?y 1)) (live-cell ?x ?y)))
    (assert (neighbor (row (+ ?x 1)) (column(- ?y 1)) (live-cell ?x ?y)))
    (assert (neighbor (row (+ ?x 1)) (column ?y ) (live-cell ?x ?y)))
    (assert (neighbor (row (+ ?x 1)) (column(+ ?y 1)) (live-cell ?x ?y)))
)

(defrule COMPUTE-NEIGHBORS::cleanup-neighbors
    (declare(salience 20))
    ?f1 <- (neighbor (row ?x)(column ?y)(live-cell $?))
    (not(cell(row ?x)(column ?y)(status ?)))
    =>
    (retract ?f1)  
)


(defrule COMPUTE-NEIGHBORS::create-neighbor-sum
    (declare(salience 10))
    (cell(row ?x)(column ?y)(status ?))
    =>
    (assert(neighbor-sum(row ?x)(column ?y)(value 0)))
)

(defrule COMPUTE-NEIGHBORS::add-neighbor-sum
    ?f <- (neighbor (row ?x) (column ?y) (live-cell ?a ?b))
    ?q <- (neighbor-sum(row ?x)(column ?y)(value ?n))
    =>
    (retract ?f ?q)  
    (assert(neighbor-sum(row ?x)(column ?y)(value (+ ?n 1))))
)


(defrule NEXT-GENERATION::continue-life
    ?a <- (cell (row ?x)(column ?y)(status *))
    ?b <- (neighbor-sum (row ?x)(column ?y)(value 2|3))
    =>
    (retract ?a ?b)
    (assert (cell (row ?x)(column ?y)(status *)))
)

(defrule NEXT-GENERATION::end-life
    ?a <- (cell (row ?x)(column ?y)(status *))
    ?b <- (neighbor-sum (row ?x)(column ?y)(value ?c))
    (test (or (> ?c 3) (< ?c 2)))
    =>
    (retract ?a ?b)
    (assert (cell (row ?x)(column ?y)(status -)))
)

(defrule NEXT-GENERATION::new-life
    ?a <- (cell (row ?x)(column ?y)(status -))
    ?b <- (neighbor-sum (row ?x)(column ?y)(value 3))
    =>
    (retract ?a ?b)
    (assert (cell (row ?x)(column ?y)(status *)))
)

(defrule NEXT-GENERATION::continue-dead
    ?a <- (cell (row ?x)(column ?y)(status -))
    ?b <- (neighbor-sum (row ?x)(column ?y)(value ?c))
    (test (!= ?c 3))
    =>
    (retract ?a ?b)
    (assert (cell (row ?x)(column ?y)(status -)))
)