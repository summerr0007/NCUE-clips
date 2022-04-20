(deftemplate car(slot type))
(deftemplate car-object(slot trouble))
(defrule brake-trouble-1
	(car-object(trouble noise-when-brake))
	=>	
	(assert(car(type brake-trouble))))
(defrule brake-trouble-2
	(car-object(trouble noise-from-tire))
	=>	
	(assert(car(type brake-trouble))))
(defrule water-tank-trouble-1
	(car-object(trouble water-thermomter-H))
	=>	
	(assert(car(type water-tank-trouble))))
(defrule water-tank-trouble-2
	(car-object(trouble water-leak))
	=>	
	(assert(car(type water-tank-trouble))))
(defrule engine-belt-loose-1
	(car-object(trouble noise-from-engine-room))
	=>	
	(assert(car(type engine-belt-loose))))
(defrule car-battery-no-power-1
	(car-object(trouble engine-cannot-catch))
	=>	
	(assert(car(type car-battery-no-power))))
(defrule deal-with-brake-trouble
	(car(type brake-trouble))
	=>
	(printout t"brake-trouble" crlf)
	(printout t"check brake pedal and oil" crlf))
(defrule deal-with-water-tank-trouble
	(car(type water-tank-trouble))
	=>
	(printout t"water-tank-trouble" crlf)
	(printout t"repair-the-water-tank-or-add-water" crlf))
(defrule deal-with-engine-belt-loose
	(car(type engine-belt-loose))
	=>
	(printout t"engine-belt-loose" crlf)
	(printout t"change the engine belt" crlf))
(defrule deal-with-battery-no-power
	(car(type battery-no-power))
	=>
	(printout t"battery-no-power" crlf)
	(printout t"replace or charge ac car battery" crlf))