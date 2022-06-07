(deftemplate permutation (multislot values)(multislot rest))

(deffacts initial (total 0))

(defrule read-base-fact
	(declare(salience 100))
	=>
	(printout t "Please input a base fact for permutation ... ")
	(bind ?input(explode$(readline)))
	(assert(permutation(values)(rest ?input)))
)
(defrule move
	(permutation (values $?v1)(rest $?r1 ?x $?r2))
	=>
	(assert(permutation (values $?v1 ?x)(rest $?r1 $?r2)))
)
(defrule sum
	?o-p<-(permutation(values $?s1)(rest ))
	?o-total<-(total ?total)
	=>
	(retract ?o-p ?o-total)
	(assert(total(+ ?total 1)))
	(printout t "find~"?s1 ?total crlf)
)
(defrule p
	(declare(salience -100))
	(total ?total)
	=>
	(printout t "" ?total crlf)
)