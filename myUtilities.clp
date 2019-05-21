/*
* Rohan Thakur
* Date Created: 2/1/19
*
* a toolbox for JESS
*/

/*
* validates that the input is a non-negative number and returns
* true if it is valid, false otherwise
*/
(deffunction checkNonNeg (?x)
   (if (and (numberp ?x) (>= ?x 0L)) then
      (bind ?x TRUE)
    else
      (bind ?x FALSE)
   )

   (return ?x)
) ; deffunction checkNonNeg (?x)

/*
* validates that the input is a positive number and returns
* true if it is valid, false otherwise
*/
(deffunction checkPos (?x)
   (if (and (numberp ?x) (> ?x 0L)) then
      (bind ?x TRUE)
    else
      (bind ?x FALSE)
   )

   (return ?x)
) ; deffunction checkPos (?x)

/*
* casts a number to a long without crashing JESS and returns the
* newly-casted number
*
* precondition: x is a number
*/
(deffunction castLong (?x)
   (if (not (longp ?x)) then
      (bind ?x (long ?x))
   )

   (return ?x)
) ; deffunction castLong (?x)

/*
* returns the list of the characters in the input string
*
* precondition: the input is a string or can be interpreted as one
*/
(deffunction slice$ (?str)
   (bind ?str (explode$ ?str))
   (bind ?ans (create$))

   (for (bind ?i 1) (<= ?i (length$ ?str)) (++ ?i)
      (bind ?word (nth$ ?i ?str))

      (for (bind ?j 1) (<= ?j (str-length ?word)) (++ ?j)
         (bind ?ans (insert$ ?ans (+ (length$ ?ans) 1) (sub-string ?j ?j ?word)))
      )
   )

   (return ?ans)
) ; deffunction slice$ (?str)

/*
* checks if the input is a 4-letter word
*/
(deffunction checkIfFourLetterWord (?s)
   (bind ?ans TRUE)

   (if (not (= (str-length ?s) 4)) then
      (bind ?ans FALSE)
   )

   (return ?ans)
) ; deffunction checkIfFourLetterWord (?s)

/*
* asserts each letter in the given list at an increasing position
* by iterating through the list and assigning the position value of
* the letter to its index
*/
(deffunction assertList (?list)
   (for (bind ?i 1) (<= ?i (length$ ?list)) (++ ?i)
      (bind ?l (nth$ ?i ?list))
      (assertLetter ?l ?i)
   )

   (return)
) ; deffunction assertList (?list)

/*
* scolds the user for not entering y or n and continues to re-ask the question until the user enters
* a valid answer
*
* returns the user's valid answer
*/
(deffunction chastiseTheUserForYesNoQuestions (?questionToAsk)
   (printline "")
   (printline "Please enter something that begins with y or n.")
   (printline "")

   (bind ?ans (lowCaseFirstChar (ask ?questionToAsk)))

   (while (not (or (eq ?ans "y") (eq ?ans "n"))) do
      (printline "")
      (printline "Please enter something that begins with y or n.")
      (printline "")

      (bind ?ans (lowCaseFirstChar (ask ?questionToAsk)))
   ) ; while (not (or (eq ?ans "y") (eq ?ans "n")))

   (return ?ans)
) ; deffunction chastiseTheUserForYesNoQuestions (?questionToAsk)

/*
* returns the first character, converted to lower case, of a string
*/
(deffunction lowCaseFirstChar (?str)
   (return (lowcase (sub-string 1 1 ?str)))
)

/*
* re-runs the rule engine
*/
(deffunction runAgain ()
   (reset)
   (run)

   (return)
) ; deffunction runAgain ()