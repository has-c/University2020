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

(deffunction led-status-question (?question)
   (bind ?response (ask-question ?question off blinking solid))
   (if (or (eq ?response off) (eq ?response blinking))
        then 
        (if (eq ?response off)
            then off
            else blinking
        )
    else
    solid))
       


;;;********************************
;;;* STARTUP AND CONCLUSION RULES *
;;; Reference: Adapted from auto.clp
;;;********************************

(defrule system-banner ""
  (declare (salience 10))
  =>
  (printout t crlf crlf)
  (printout t "Laptop Start-up Problem Diagnosis Expert System: ")
  (printout t "This expert system diagnoses some simple problems when your laptop won't start")
  (printout t crlf crlf))

(defrule print-repair ""
  (declare (salience 10))
  (repair ?item)
  =>
  (printout t crlf crlf)
  (printout t "Suggested Action:")
  (printout t crlf crlf)
  (format t " %s%n%n%n" ?item))

;;;***************
;;;* QUERY RULES *
;;; Reference: Adapted from auto.clp
;;;***************

(defrule determine-laptop-state ""
   (not (laptop-starts ?))
   (not (repair ?))
   =>
   (assert (laptop-starts (yes-or-no-p "Is the laptop starting normally (yes/no)? "))))
   
(defrule determine-anything-on-screen ""
   (laptop-starts no)
   (not (repair ?))
   =>
   (assert (screen-on (yes-or-no-p "Is there anything on the screen (yes/no)? "))))

(defrule determine-error-message ""
   (screen-on yes)
   (not (repair ?))
   =>
   (assert (error-message (yes-or-no-p "Is there an error message on the screen? (yes/no)? "))))

(defrule determine-power-cord-status ""
   (screen-on no)
   (not (repair ?))
   =>
   (assert (power-cord-status (yes-or-no-p "Is the power cord plugged in? (yes/no)? "))))

(defrule determine-wall-outlet-switch-status ""
   (power-cord-status yes)
   (not (repair ?))
   =>
   (assert (wall-outlet-switch-status (yes-or-no-p "Is switch on the wall turned on? (yes/no)? "))))

(defrule determine-LED-charger-status""
   (wall-outlet-switch-status yes)
   (not (repair ?))
   =>
   (assert (LED-charger-status (led-status-question "What is the LED on the charger doing? (off/blinking/solid)? "))))

(defrule determine-wall-outlet-working""
   (LED-charger-status off)
   (not (repair ?))
   =>
   (assert (wall-outlet-working (yes-or-no-p "Is the wall outlet working (yes/no)? "))))

(defrule determine-mains-power-working""
   (wall-outlet-working no)
   (not (repair ?))
   =>
   (assert (mains-power-working (yes-or-no-p "Is the mains power on (yes/no)? "))))

;;;****************
;;;* REPAIR RULES *
;;; Reference: Adapted from auto.clp
;;;****************

(defrule normal-laptop-state-conclusions ""
   (laptop-starts yes)
   (not (repair ?))
   =>
   (assert (repair "No repair needed.")))

(defrule error-message-conclusion-yes ""
   (error-message yes)
   (not (repair ?))
   =>
   (assert (repair "Please google the specified error message to receive further aid.")))

(defrule error-message-conclusion-no ""
   (error-message no)
   (not (repair ?))
   =>
   (assert (repair "Please call tech support to help with your problem.")))

(defrule power-cord-conclusion ""
   (power-cord-status no)
   (not (repair ?))
   =>
   (assert (repair "Please plug in and try starting your laptop again.")))

(defrule wall-outlet-switch-conclusion ""
   (wall-outlet-switch-status no)
   (not (repair ?))
   =>
   (assert (repair "Please turn switch on and try starting your laptop again.")))

(defrule charger-LED-conclusion-blinking ""
   (LED-charger-status blinking)
   (not (repair ?))
   =>
   (assert (repair "Something is wrong with the charger. Please replace it and try starting your laptop again.")))

(defrule charger-LED-conclusion-solid ""
   (LED-charger-status solid)
   (not (repair ?))
   =>
   (assert (repair "Laptop is charging. Please wait a few minutes before trying to start again.")))

(defrule wall-outlet-working-conclusion ""
   (wall-outlet-working yes)
   (not (repair ?))
   =>
   (assert (repair "Charger is broken. Please replace before trying again.")))

(defrule mains-power-working-conclusion-yes ""
   (mains-power-working yes)
   (not (repair ?))
   =>
   (assert (repair "Wall outlet is broken. Please replace it before trying again.")))

(defrule mains-power-working-conclusion-no ""
   (mains-power-working no)
   (not (repair ?))
   =>
   (assert (repair "Something is wrong with the mains power source. Please call an electrician.")))
