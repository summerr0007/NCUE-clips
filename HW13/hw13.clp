(deftemplate salary
    0 100000 NTD
    (
        (High (25000 0)(45000 0.9)(60000 1))
    )
)

(deftemplate hours
    0 168 HOUR
    (
        (Low (20 1)(40 0.7)(50 0))
    )
)

(deftemplate distance
    0 300 KM
    (
        (Near (5 1)(20 0.8)(100 0))
    )
)

(deftemplate profit
    0 10000 M
    (
        (High (10 0)(100 1))
    )
)

(deftemplate stock-price
    0 3000 NTD
    (
        (High (10 0)(100 0.8)(500 1))
    )
)

(deftemplate job
    (slot ID)
    (slot pay (type FUZZY-VALUE salary))
    (slot working-hours (type FUZZY-VALUE hours))
    (slot away-from(type FUZZY-VALUE distance))
    (slot company-profit (type FUZZY-VALUE profit))
    (slot company-stock (type FUZZY-VALUE stock-price))
)

(deffacts initial
  (job (ID 1) (pay (40000 0) (40000 1) (40000 0)) (working-hours (40 0) (40 1) (40 0)) (away-from (17 0) (17 1) (17 0)) 
       (company-profit (60 0) (60 1) (60 0)) (company-stock (55 0) (55 1) (55 0)))
  (job (ID 2) (pay (30000 0) (30000 1) (30000 0)) (working-hours (35 0) (35 1) (35 0)) (away-from (12 0) (12 1) (12 0)) 
       (company-profit (200 0) (200 1) (200 0)) (company-stock (87 0) (87 1) (87 0)))
  (job (ID 3) (pay (50000 0) (50000 1) (50000 0)) (working-hours (45 0) (45 1) (45 0)) (away-from (50 0) (50 1) (50 0)) 
       (company-profit (40 0) (40 1) (40 0)) (company-stock (20 0) (20 1) (20 0)))
  (job (ID 4) (pay (27000 0) (27000 1) (27000 0)) (working-hours (32 0) (32 1) (32 0)) (away-from (5 0) (5 1) (5 0)) 
       (company-profit (150 0) (150 1) (150 0)) (company-stock (293 0) (293 1) (293 0)))
)

(defrule match-pay 
    (declare (CF 1.0))
    (job(ID ?id)(pay High))
    =>
    (assert (high-pay ?id))
)

(defrule match-hours 
    (declare (CF 0.7))
    (job(ID ?id)(working-hours Low))
    =>
    (assert (low-hours ?id))
)

(defrule match-distance 
    (declare (CF 0.5))
    (job(ID ?id)(away-from Near))
    =>
    (assert (near-distance ?id))
)

(defrule match-profit 
    (declare (CF 0.1))
    (job(ID ?id)(company-profit High))
    =>
    (assert (high-profit ?id))
)

(defrule match-stock-price 
    (declare (CF 0.2))
    (job(ID ?id)(company-stock High))
    =>
    (assert (high-stock ?id))
)

(defrule add-print
    ?f1 <-(high-stock ?id)
    ?f2 <-(high-profit ?id)
    ?f3 <-(near-distance ?id)
    ?f4 <-(low-hours ?id)
    ?f5 <-(high-pay ?id)
    =>
    (printout t "job : " ?id " Degree : " (/ (+ (get-cf ?f1) (get-cf ?f2) (get-cf ?f3) (get-cf ?f4) (get-cf ?f5)) 2.5) crlf)
)