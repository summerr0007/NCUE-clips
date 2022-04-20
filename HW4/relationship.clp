(deftemplate sort
    (slot super)
    (slot sub)
)

(deftemplate relationship
    (multislot sort01)
    (multislot sort02)
)

(deffacts initial
    (sort (super Mammalia) (sub Primates))
    (sort (super Mammalia) (sub Artiodactyla))
    (sort (super Mammalia) (sub Rodentia))
    (sort (super Primates) (sub Cercopithecidae))
    (sort (super Primates) (sub Hominoidea))
    (sort (super Artiodactyla) (sub Cervidae))
    (sort (super Artiodactyla) (sub Bovidae))
    (sort (super Rodentia) (sub Sciuridae))
    (sort (super Cercopithecidae) (sub Macaca))
    (sort (super Cercopithecidae) (sub Papio))
    (sort (super Cercopithecidae) (sub Mandrillus))
    (sort (super Hominoidea) (sub Pongo))
    (sort (super Hominoidea) (sub Pan))
    (sort (super Hominoidea) (sub Homo))
    (sort (super Cervidae) (sub Rangifer))
    (sort (super Cervidae) (sub Elaphurus))
    (sort (super Bovidae) (sub Bison))
    (sort (super Bovidae) (sub Bubalus))
    (sort (super Sciuridae) (sub Tamias))
    (sort (super Macaca) (sub Sylvanus))
    (sort (super Macaca) (sub Cyclopis))
    (sort (super Papio) (sub Anubis))
    (sort (super Papio) (sub Ursinus))
    (sort (super Mandrillus) (sub Sphinx))
    (sort (super Mandrillus) (sub Leucophaeus))
    (sort (super Pongo) (sub Pygmaeus))
    (sort (super Pongo) (sub Abelii))
    (sort (super Pan) (sub Troglodytes))
    (sort (super Pan) (sub Paniscus))
    (sort (super Homo) (sub Sapiens))
    (sort (super Rangifer) (sub Tarandus))
    (sort (super Rangifer) (sub Caribou))
    (sort (super Elaphurus) (sub Davidianus))
    (sort (super Bison) (sub Athabascae))
    (sort (super Bison) (sub Bonasus))
    (sort (super Bubalus) (sub Arnee))
    (sort (super Tamias) (sub Ochrogenys))
    (phase input)

)

(defrule input
    (phase input)
    =>
    (printout t"Enter sort #1 ")
    (bind ?input1(read))
    (printout t"Enter sort #2 ")
    (bind ?input2(read))
    (assert (relationship(sort01 ?input1)(sort02 ?input2)))
)

(defrule a1
    (phase input)
    ?old <- (relationship(sort01 ?x $?t )(sort02 $?g))
    (sort(super ?y)(sub ?x))
    =>
    (retract ?old)
    (assert (relationship(sort01 ?y ?x $?t)(sort02 $?g)))

)

(defrule a2
    (phase input)
    ?old <- (relationship(sort01 $?g )(sort02 ?x $?t))
    (sort(super ?y)(sub ?x))
    =>
    (retract ?old)
    (assert (relationship(sort01 $?g )(sort02 ?y ?x $?t)))
)

(defrule change-phase
    (declare(salience -10))
    ?f1 <- (phase input)
    => (retract ?f1)
    (assert (phase erase))
)

(defrule erase
    (phase erase)
    ?old <- (relationship(sort01 ?x $?a)(sort02 ?x $?b))
    =>
    (retract ?old)
    (assert(relationship(sort01 $?a)(sort02 $?b)))
)

(defrule end 
    (declare(salience -100))
    (relationship(sort01 $?sort01)(sort02 $?sort02))
    =>
    (printout t"The relationship distance is "(+ (length$ $?sort01)(length$ $?sort02)) crlf )
)