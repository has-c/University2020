;;;======================================================
;;;   Laptop Start Expert System
;;;
;;;     This expert system diagnoses some simple
;;;     problems when your laptop won't start.
;;;
;;;     To execute, merely load, reset and run.
;;;======================================================


;;****************
;;* DEFFUNCTIONS *
;; Reference: Copied from auto.clp
;;****************

(deffunction ask-question (?question $?allowed-values)
   (printout t ?question)
   (bind ?answer (read))
   (if (lexemep ?answer) 
       then (bind ?answer (lowcase ?answer)))
   (while (not (member ?answer ?allowed-values)) do
      (printout t ?question)
      (bind ?answer (read))
      (if (lexemep ?answer) 
          then (bind ?answer (lowcase ?answer))))
   ?answer)

(deffunction yes-or-no-p (?question)
   (bind ?response (ask-question ?question yes no y n))
   (if (or (eq ?response yes) (eq ?response y))
       then yes 
       else no))


;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;; Reference: Copied from auto.clp
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Laptop Start-up Problem Diagnosis Expert System")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Action:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))