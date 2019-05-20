/*
** January 18, 2019
** Dr. Eric R. Nelson
**
** Small collection of JESSS utilities for ATCS:Expert Systems
**
** print       - prints any argument
** printline   - print followed by a newline
** ask         - prompt the user and read back a token
** askline     - prompt the user and read back a line of text (a string)
** askQuestion - adds a question mark to the prompt used in ask
** toChar      - given an ASCII integer value, returns the ASCII character as a string
** boolp       - Test for boolean type
** xor         - Exclusive-OR for two boolean values
*/

/*
** Function that prints out a prompt (it's just a bit shorter than using (printout t "text")
*/
(deffunction print (?arg)
   (printout t ?arg)
   (return)
)

/*
** print with a new-line at the end
*/
(deffunction printline (?arg)
   (print ?arg)
   (printout t crlf)
   (return)
)

/*
** ask the user for input and return a token
*/
(deffunction ask (?arg)
   (print ?arg)
   (return (read))
)

/*
** Same as ask but returns a string of text
*/
(deffunction askline (?arg)
   (print ?arg)
   (return (readline))
)

/*
** Appends a question mark to the prompt of the ask function
*/ 
(deffunction askQuestion (?arg)
   (print ?arg)
   (return (ask "? "))
)

/*
** This function returns the character given a number.
** The format function is just printf() in C, but unlike printout this function returns the output,
** so if you use a nil router you don't get a printout, just the return value. A thanks goes to Henry W. for finding this out.
*/
(deffunction toChar (?ascii)
   (return (format nil "%c" (integer ?ascii)))
)

/*
** Tests is the argument is a boolean, which can only take on the value of TRUE and FALSE 
*/
(deffunction boolp (?x)
   (return (or (eq ?x TRUE) (eq ?x FALSE)))
)

/*
** Simple exclusive-or function
** 
** Function assumes values are either TRUE or FALSE
*/
(deffunction xor (?a ?b)
   (return (and (or ?a ?b) (not (and ?a ?b))))
)

