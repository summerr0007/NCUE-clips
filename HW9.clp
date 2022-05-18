(deftemplate set (multislot name )(multislot members))

(deffacts initial (phase load-data))
(defrule assert-data
    ?f1 <-(phase load-data)
    => 
    (retract ?f1)
    (open "set.txt" out "w")
    (assert (phase input))
)

(defrule input-number
    (phase input)
    =>
    (printout t"Please input a set s1: " )
    (assert (set (name s1)(members (explode$ (readline)))))
    (printout t"Please input a set s2: " )
    (assert (set (name s2)(members (explode$ (readline)))))
    (assert(set (name s1 intersect s2)(members)))
)

(defrule check-input-error-1
    ?f1<-(phase input)
    ?f2<-(set(name ?t1 )(members $? ?a $? ?a $?))
    ?f3<-(set (name ?t2&~?t1)(members $?))
    =>
    (retract ?f1 ?f2 ?f3)
    (printout t"Input error!! Duplicate elements are not allowd in set!!" crlf)
    (assert (phase input))
)

(defrule check-input-error-2
    ?f1<-(phase input)
    ?f2<-(set(name ?t1 )(members $? ?a $?))
    ?f3<-(set (name ?t2&~?t1)(members $?))
    (test(not (integerp ?a)))
    =>
    (retract ?f1 ?f2 ?f3)
    (printout t"Input error!! Some elements are not intgers!!" crlf)
    (assert (phase input))
)

(defrule input-no-error
    (declare (salience -10))
    ?f<-(phase input)
    => 
    (retract ?f)
    (assert (phase compute))
)

(defrule compute1
    ?f1<-(phase compute)
    ?f2<-(set(name ?t1 )(members $?a))
    ?f3<-(set (name ?t2&~?t1)(members $?b))
    =>
    (retract ?f1)
    (assert(phase compute2))
    (assert (set (name ?t1 union ?t2)(members $?a $?b)))
)

(defrule compute2
    ?f1<-(phase compute2)
    ?f2<-(set(name ?t1 )(members $? ?a $?))
    ?f3<-(set (name ?t2&~?t1)(members $? ?a $?))
    ?f4<-(set (name $? intersect $?)(members $?c))
    (test(not(member$ ?a $?c)))
    =>
    (retract ?f4)
    (assert (set (name ?t1 intersect ?t2)(members ?a $?c)))
)

(defrule change-phase-3
    (declare (salience -10))    
    (phase compute2)
    =>
    (assert(phase sort))
)



(defrule sort
    (phase sort)
    ?f<-(set(name $?id)(members $?i1 ?a ?b $?i2))
    (test (> ?a ?b))
    =>
    (retract ?f)
    (assert(set(name $?id)(members $?i1 ?b ?a $?i2)))
)

(defrule sort2
    (phase sort)
    ?f<-(set(name $?id)(members $?i1 ?a ?b $?i2))
    (test (= ?a ?b))
    =>
    (retract ?f)
    (assert (set(name $?id)(members $?i1 ?b  $?i2)))
)

(defrule change-phase-4
    (declare (salience -10))
    (phase sort)
    =>
    (assert(phase print))
)

(defrule print1
    (phase print)
    (set(name $?id)(members $?a))
    =>
    (printout out "(set (name "$?id")(members "$?a"))" crlf)
)
(defrule close
    (declare (salience -10))
    (phase print)
    =>
    (close out)
)