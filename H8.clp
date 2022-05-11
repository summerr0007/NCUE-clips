(deftemplate sales(slot id)(multislot items))
(deftemplate same (multislot pair)(multislot items))
(deftemplate recommend (slot id)(multislot similar)(multislot items))

(deffacts initial (phase load-data))
(defrule assert-data
    (phase load-data)
    => 
    (load-facts "record-01.txt")
    (open "recommend.txt" out "w")
)

(defrule generate-recommend
    (phase load-data)
    (sales (id ?id1)(items $?))
    =>
    (assert (recommend (id ?id1 )(similar)(items)))
)

(defrule generate-same-pair
    (phase load-data)
    (sales (id ?id1)(items $?))
    (sales (id ?id2&~?id1)(items $?))
    =>
    (assert (same(pair ?id1 ?id2)(items)))
)

(defrule generate-same-items
    (phase load-data)
    ?f <- (same(pair ?id1 ?id2)(items $?items))
    (sales (id ?id1) (items $? ?x $?))
    (sales (id ?id2) (items $? ?x $?))
    (test(not(member$ ?x $?items)))
    =>
    (retract ?f)
    (assert (same (pair ?id1 ?id2)(items $?items ?x)))
)

(defrule change-phase-1
    (declare (salience -10))
    (phase load-data)
    =>
    (assert (phase find-similar))
)

(defrule find-long
    (phase find-similar)
    (same(pair ?p1 $?)(items $?items1))
    ?f <- (same(pair ?p1 $?)(items $?items2))
    (test(< (length$ $?items2) (length$ $?items1)))
    =>
    (retract ?f)
)

(defrule change-phase-2
    (declare (salience -15))
    (phase find-similar)
    =>
    (assert (phase add-recommend))
)

(defrule add-recommend-1
    (phase add-recommend)
    ?f<-(recommend(id ?id1)(similar $?s)(items $?o))
    ?old <-(same (pair ?id1 $?id2)(items $?items1))
    =>
    (retract ?f ?old)
    (assert (recommend(id ?id1 )(similar $?s $?id2)(items $?o $?items1)))
)
