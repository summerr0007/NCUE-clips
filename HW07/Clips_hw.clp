(deftemplate binary-# (multislot name)(multislot digits))
(deftemplate binary-adder (multislot name-1)(multislot name-2)(slot carry)(multislot #-1)(multislot #-2)(multislot result))
(deffacts initial-fact (phase input-amount)(number 0))

(defrule input-amount
	(phase input-amount)
	=>
	(printout t"Please input the amount of binary numbers to be added:")
	(assert(amount(read))))
	
(defrule amount-error
	?p<-(phase input-amount)
	?a<-(amount ?amount)
	(test (or (not(integerp ?amount))(<= ?amount 0)))
	=>
	(retract ?p ?a)
	(assert(phase input-amount))
	(printout t"Please input a positive integer!!" crlf))
	
(defrule amount-true
	?p<-(phase input-amount)
	(amount ?amount)
	(test (integerp ?amount))
	(test (> ?amount 0))
	=>
	(retract ?p)
	(assert (phase input-binary-#)))
	
(defrule input-binary-#
	?p<-(phase input-binary-#)
	(amount ?a)
	?f<-(number ?n)
	(test (< ?n ?a))
	=>
	(retract ?f ?p)
	(printout t"Please input binary number #"(+ ?n 1)": ")
	(assert(phase input-check))
	(assert(binary-#(name(+ ?n 1))(digits(explode$(readline)))))
	(assert(number(+ ?n 1))))

(defrule input-error
	?p<-(phase input-check)
	?number<-(number ?n)
	?b<-(binary-#(name ?name)(digits $? ?f $?))
	(test (neq ?f 0))
	(test (neq ?f 1))
	=>
	(retract ?p ?b ?number)
	(assert (number(- ?n 1)))
	(assert (phase input-binary-#))
	(printout t"Input error!! Please input binary numbers!!" crlf))

(defrule input-right
	?p<-(phase input-check)
	(number ?n)
	(amount ?a)
	(test (neq ?n ?a))
	=>
	(retract ?p)
	(assert (phase input-binary-#)))
	
(defrule input-done
	?p<-(phase input-check)
	=>
	(retract ?p)
	(assert (phase add-binary-#)))
	
(defrule create-adder
	(declare(salience 10))
	(phase add-binary-#)
	?f1<-(binary-#(name $?n1)(digits $?d1))
	?f2<-(binary-#(name $?n2&~$?n1)(digits $?d2))
	=>
	(retract ?f1 ?f2)
	(assert(binary-adder(name-1 ?n1)(name-2 ?n2)(carry 0)(#-1 ?d1)(#-2 ?d2)(result))))

(defrule adder-case-1
	?f<-(binary-adder(carry ?c)(#-1 $?n1 ?d1)(#-2 $?n2 ?d2)(result $?r))
	=>
	(modify ?f(carry (integer (/(+ ?c ?d1 ?d2)2)))
			  (result (mod(+ ?c ?d1 ?d2)2) ?r)(#-1 ?n1)(#-2 ?n2)))
			  
(defrule adder-case-2
	?f<-(binary-adder(carry ?c)(#-1)(#-2 ?d2)(result $?r))
	=>
	(modify ?f(carry (integer (/(+ ?c ?d2)2)))
			  (result (mod(+ ?c ?d2)2) ?r)(#-1 )(#-2)))
			  
(defrule adder-case-3
	?f<-(binary-adder(carry ?c)(#-1 ?d1)(#-2 )(result $?r))
	=>
	(modify ?f(carry (integer (/(+ ?c ?d1)2)))
			  (result (mod(+ ?c ?d1)2) ?r)(#-1)(#-2)))

(defrule adder-case-4
	?f<-(binary-adder(carry 1)(#-1)(#-2)(result $?r))
	=>
	(modify ?f(carry 0)
			  (result 1 ?r)(#-1)(#-2)))

(defrule convert-adder-to-number
	?f1<-(binary-adder(name-1 $?n1)(name-2 $?n2)(carry 0)(#-1)(#-2)(result $?r))
	=>
	(retract ?f1)
	(assert (binary-#(name { ?n1 + ?n2 })(digits ?r))))
	
(defrule printout
	(declare (salience -10))
	(binary-#(name $?n)(digits $?r))
	=>
	(printout t ?n ":" ?r crlf))