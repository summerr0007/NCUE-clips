(deftemplate sales(slot id)(multislot items))
(deftemplate same (multislot pair)(multislot items))
(deftemplate recommend (slot id)(multislot similar)(multislot items))
(deftemplate recommend2 (slot id)(multislot similar)(multislot items))

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
    (assert (recommend(id ?id1 )(similar $?s $?id2)(items )))
)

(defrule change-phase-5
    (declare (salience -15))
    (phase add-recommend)
    =>
    (assert (phase add-recommend2))
)

(defrule add-recommend-2
    (phase add-recommend2)
    ?f<-(recommend(id ?id1)(similar $?a ?id2 $?b)(items $?items1))    
    (sales (id ?id2)(items $? ?x $?))
    (sales (id ?id1)(items $?items))
    (test(not(member$ ?x $?items)))
    (test(not(member$ ?x $?items1)))
    =>
    (retract ?f)
    (assert (recommend(id ?id1 )(similar $?a ?id2 $?b)(items ?x $?items1)))
)



(defrule change-phase-3
    (declare (salience -15))
    (phase add-recommend)
    =>
    (assert (phase sort))
)

(defrule sort
    (phase sort)
    ?f<-(recommend(id ?id)(similar $?x)(items $?i1 ?a ?b $?i2))
    (test (> ?a ?b))
    =>
    (retract ?f)
    (assert(recommend(id ?id)(similar $?x)(items $?i1 ?b ?a $?i2)))
)

(defrule sort2
    (phase sort)
    ?f<-(recommend(id ?id)(similar $?x)(items $?i1 ?a ?b $?i2))
    (test (= ?a ?b))
    =>
    (retract ?f)
    (assert(recommend(id ?id)(similar $?x)(items $?i1 ?b  $?i2)))
)

(defrule change-phase-4
    (declare (salience -10))
    (phase sort)
    =>
    (assert(phase print)))

(defrule print
    (phase print)
    (recommend(id ?id)(similar $?a)(items $?items))
    =>
    (printout out ?id ""$?a":"$?items   crlf))
(defrule close
    (declare (salience -10))
    (phase print)
    =>
    (close out))
