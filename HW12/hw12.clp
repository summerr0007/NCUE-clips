(deftemplate level
    1 7
    (
        (Good (1 1) (5 0))
        (Average (1 0) (4 1) (7 0))
    )
)
(deftemplate rank
    1 99 Percent
    (
        (High (10 1) (70 0))
    )
)
(deftemplate grade
    1 15
    (
        (High (7 0) (13 0.8) (15 1))
    )
)
(deftemplate school
    (slot ID)
    (slot evaluation (type FUZZY-VALUE level))
)
(deftemplate student
    (slot ID)
    (slot school-ID)
    (slot GPA-rank (type FUZZY-VALUE rank))
    (slot math (type FUZZY-VALUE grade))
    (slot nature (type FUZZY-VALUE grade))
)
(deffacts initial
   (school (ID 1) (evaluation (2 0) (2 1) (2 0)))
   (school (ID 2) (evaluation (4 0) (4 1) (4 0)))
   (school (ID 3) (evaluation (6 0) (6 1) (6 0)))
   (student (ID 1) (school-ID 1) (GPA-rank (58 0) (58 1) (58 0)) (math (14 0) (14 1) (14 0)) (nature (13 0) (13 1) (13 0)))
   (student (ID 2) (school-ID 1) (GPA-rank (51 0) (51 1) (51 0)) (math (11 0) (11 1) (11 0)) (nature (9 0) (9 1) (9 0)))
   (student (ID 3) (school-ID 1) (GPA-rank (40 0) (40 1) (40 0)) (math (13 0) (13 1) (13 0)) (nature (11 0) (11 1) (11 0)))
   (student (ID 4) (school-ID 2) (GPA-rank (47 0) (47 1) (47 0)) (math (11 0) (11 1) (11 0)) (nature (12 0) (12 1) (12 0)))
   (student (ID 5) (school-ID 2) (GPA-rank (39 0) (39 1) (39 0)) (math (12 0) (12 1) (12 0)) (nature (10 0) (10 1) (10 0)))
   (student (ID 6) (school-ID 2) (GPA-rank (20 0) (20 1) (20 0)) (math (13 0) (13 1) (13 0)) (nature (12 0) (12 1) (12 0)))
   (student (ID 7) (school-ID 3) (GPA-rank (12 0) (12 1) (12 0)) (math (15 0) (15 1) (15 0)) (nature (8 0) (8 1) (8 0)))
   (student (ID 8) (school-ID 3) (GPA-rank (21 0) (21 1) (21 0)) (math (12 0) (12 1) (12 0)) (nature (10 0) (10 1) (10 0)))
   (student (ID 9) (school-ID 3) (GPA-rank (33 0) (33 1) (33 0)) (math (12 0) (12 1) (12 0)) (nature (11 0) (11 1) (11 0)))
   (total 0)
)
(defrule Good-student
    ?f1<-(student (ID ?i)(school-ID ?s)(GPA-rank somewhat High)(math High)(nature somewhat High))
    (school (ID ?s)(evaluation Good))
    ?f2<-(total ?t)
    =>
    (retract ?f1 ?f2)
    (assert (total (+ ?t 1)))
    (printout t "Recommend Student " ?i crlf)
)
(defrule Average-student
    ?f1<-(student (ID ?i)(school-ID ?s)(GPA-rank High)(math High)(nature somewhat High))
    (school (ID ?s)(evaluation Average))
    ?f2<-(total ?t)
    =>
    (retract ?f1 ?f2)
    (assert (total (+ ?t 1)))
    (printout t "Recommend Student " ?i crlf)
)
(defrule Bad-student
    ?f1<-(student (ID ?i)(school-ID ?s)(GPA-rank very High)(math High)(nature somewhat High))
    (school (ID ?s)(evaluation not Good))
    ?f2<-(total ?t)
    =>
    (retract ?f1 ?f2)
    (assert (total (+ ?t 1)))
    (printout t "Recommend Student " ?i crlf)
)
(defrule print
    (declare(salience -10))
    (total ?t)
    =>
    (printout t "Total: " ?t crlf)
)