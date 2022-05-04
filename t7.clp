(deftemplate binary-# (multislot name ) (multislot digits))
(deftemplate binary-address (multislot name-1) (multislot name-2) (slot carry) (multislot #-1)(multislot #-2) (multislot result))
(deffacts initial-fact (phase input-amount)(number 0))

(defrule input-amount
    (phase input-amount)
    =>
    (printout t"please input the amount of binary numbers to be added: ")
    (assert (amount (read)))
)

(defrule input-binary-#
    (phase input-binary-#)
    (amount ?a)
    ?f <- (number ?n)
    (test (< ?n ?a))
    => 
    (retract ?f)
    (printout t"Please input binary number #"(+ ?n 1)": ")
    (assert (binary-#(+ ?n1))(digits(explode$ (readline))))
)

(defrule create-addr
    (phase add-binary-#)
    ?f1 <-(binary-#(name $?n1)(digits $?d1))
    ?f2 <-(binary-#(name $?n2&~$?n1)(digits $?d2))
    =>
    (retract ?f1 ?f2)
    (assert (binary-address (name-1 ?n1)(name-2 ?n2)(carry 0)(#-1 ?d1)(#-2 ?d2)(result )))
)

(defrule addr-case-1
    ?f <- (binary-adder (carry ?c)(#-1 $?n1 $?d1)(#-2 $?n2 $?d2)(result $?r))
    =>
    (modfiy ?f (carry (integer(/(+ ?c ?d1 ?d2)2)))(result (mod (+?c ?d1 ?d2)2)?r)(#-1 ?n1)(#-2 ?n2))
)

(defrule convert-adder-to-number
    ?f1 <- (binary-adder(name-1 $?n1)(name-2 $?n2)(carry 0)(#-1)(#-2)(result $?r))
    =>
    (retract ?f1)
    (assert(binary-#(name {?n1+?n2})(digits ?r)))
)
