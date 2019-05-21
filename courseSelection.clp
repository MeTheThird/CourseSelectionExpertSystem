/*
* Rohan Thakur
* Date Created: 5/1/19
*
* An Expert System that helps a Harker high school freshman decide on which courses they should take
* in their sophomore year based on backward-chained attributes.
*/





(clear)
(reset)

(batch utilities_v2.clp)
(batch myUtilities.clp) ; contains lowCaseFirstChar, chastiseTheUserForYesNoQuestions, runAgain

(defglobal ?*courseList* = (list))                     ; the list that will be populated with the
                                                       ; sophomore courses that the ES suggests the
                                                       ; user should take
(defglobal ?*TOTAL_COURSE_SLOTS* = 6)                  ; the total number of non-Extra Period Option
                                                       ; courses that a student can take
(defglobal ?*courseSlotsLeft* = ?*TOTAL_COURSE_SLOTS*) ; the number of non-Extra Period Option slots
                                                       ; that haven't been taken by a course
(defglobal ?*prevInterest* = "")                       ; the user's area of interest for their first
                                                       ; elective
(defglobal ?*MANAGEABLE_NUM_OF_APS* = 2)               ; the number of APs beyond which one's
                                                       ; sophomore year could be too much work


(defglobal ?*STARTUP_RULE_SALIENCE* = 100)          ; very high to ensure that the startup rule
                                                    ; fires first
(defglobal ?*END_RULE_SALIENCE* = -100)             ; very low to ensure that the end rule fires
                                                    ; last
(defglobal ?*AREA_OF_INTEREST_RESET_SALIENCE* = -99) ; one more than END_RULE_SALIENCE to ensure that
                                                    ; areaOfInterest is reset before ending the ES's
                                                    ; processing


/*
* the list of attributes that have honors or regular as values, and the list is used to dynamically
* create the attributes' backward-chaining rules
*/
(defglobal ?*LIST_OF_HR_ATTRIBUTES* = (list englishLevel
                                            historyLevel
                                            physicsLevel
                                            mathLevel
                                            languageLevel
                                      ) ; list
) ; defglobal ?*LIST_OF_HR_ATTRIBUTES*

/*
* the corresponding list of questions to ask the user for dynamically creating each H/R attribute's
* backward-chaining rule
*
* in this list, the attribute located at index i in LIST_OF_HR_ATTRIBUTES is also at index i in
* LIST_OF_HR_QUESTIONS
*/
(defglobal ?*LIST_OF_HR_QUESTIONS* = (list "What is your english level (enter h for honors or r for regular)? "
                                           "What is your history level (enter h for honors or r for regular)? "
                                           "What is your physics level (enter h for honors or r for regular)? "
                                           "What is your math level (enter h for honors/AP or r for regular)? "
                                           "Are you in an honors or regular foreign language class (enter h for honors/AP or r for regular)? "
                                     ) ; list
) ; defglobal ?*LIST_OF_HR_QUESTIONS*

/*
* the list of attributes for dynamically creating all of their backward-chaining rules
*/
(defglobal ?*LIST_OF_YN_ATTRIBUTES* = (list overworkingEnglish
                                            moveUpEnglish
                                            overworkingHistory
                                            wantsAPHistory
                                            wantsEuro
                                            moveUpHistory
                                            overworkingPhysics
                                            wantsAPChem
                                            canDoAPChem
                                            canDoHonorsChem
                                            overworkingMath
                                            moveUpMath
                                            overworkingLanguage
                                            continueLanguage
                                            canDoAPLanguage
                                            wantsAPLanguage
                                            moveUpLanguage
                                            moveUpPhysics
                                            takingSpanish
                                            econOverEntre
                                            wantsAPEcon
                                            startedBusiness
                                            wantsAPMusic
                                            wantsAPPhys
                                            qualPhys2
                                            qualPhysC
                                            wantsPhysC
                                            completedAPCS
                                            completedCSDS
                                            wantsAPCS
                                            wantsCSDS
                                      ) ; list
) ; defglobal ?*LIST_OF_YN_ATTRIBUTES*

/*
* the corresponding list of questions to ask the user for dynamically creating each Y/N attribute's
* backward-chaining rule
*
* in this list, the attribute located at index i in LIST_OF_YN_ATTRIBUTES is also at index i in
* LIST_OF_YN_QUESTIONS
*/
(defglobal ?*LIST_OF_YN_QUESTIONS* = (list "Do you spend significantly more time working on English than you would like to? "
                                           "Are you doing well in English and want to move up to honors? "
                                           "Do you spend significantly more time working on History than you would like to? "
                                           "Do you want to do AP History? "
                                           "Do you want to take AP European History? "
                                           "Are you doing well in history and want to move up to honors? "
                                           "Do you spend significantly more time working on Physics than you would like to? "
                                           "Do you want to take AP Chemistry? "
                                           "Do you qualify for taking AP Chemistry in 10th grade (to qualify, you need to have had an A at the end of semester 1 in Honors Physics)? "
                                           "Do you qualify for taking Honors Chemistry in 10th grade (to qualify, you need to have had at least a B in Honors Physics or an A in Physics both semesters)? "
                                           "Do you spend significantly more time working on Math than you would like to? "
                                           "Are you doing well in math and want to move up to honors? "
                                           "Do you spend significantly more time working on your foreign language than you would like to? "
                                           "Do you want to continue your foreign language? "
                                           "Are you taking either of Spanish or Latin? "
                                           "Are you doing well in your foreign language class and want to take the AP course? "
                                           "Are you doing well in your foreign language class and want to move up to honors? "
                                           "Are you doing well in Physics and want to move up to honors? "
                                           "Are you taking Spanish? "
                                           "Are you more interested in Economics than Entrepreneurship? "
                                           "Do you want to take AP Economics - Micro and Macro? "
                                           "Have you started a business? "
                                           "Do you want to take AP Music Theory and have enough musical experience to do so? "
                                           "Do you want to take AP Physics? "
                                           "Do you qualify to take AP Physics 2 (to qualify, you need to have earned at least a B+ in Honors Physics both semesters or at least an A in Physics both semesters)? "
                                           "Do you qualify to take AP Physics C (to qualify, you need to have earned at least an A- in Honors Physics both semesters)? "
                                           "Do you want to take AP Physics C? "
                                           "Will you have completed AP Computer Science by sophomore year? "
                                           "Will you have completed AP Computer Science with Data Structures by sophomore year? "
                                           "Do you want to take AP Computer Science? "
                                           "Do you want to take AP Computer Science with Data Structures? "
                                     ) ; list
) ; defglobal ?*LIST_OF_YN_QUESTIONS*

/*
* ensures that the attributes that aren't in any attribute list (because they don't conform well to
* the dynamic creation pattern) are backward chained
*/
(do-backward-chaining mathClass)
(do-backward-chaining languageClass)
(do-backward-chaining areaOfInterest)
(do-backward-chaining studyArtsClass)
(do-backward-chaining EPO_Interest)

/*
* dynamically creates the do-backward-chaining commands for the attributes in LIST_OF_HR_ATTRIBUTES
* by iterating through the list
*
* SAMPLE CODE:
* (do-backward-chaining englishLevel)
*/
(foreach ?attribute ?*LIST_OF_HR_ATTRIBUTES*
   (build (str-cat "(do-backward-chaining " ?attribute ")"))
)

/*
* dynamically creates the do-backward-chaining commands for the attributes in LIST_OF_YN_ATTRIBUTES
* by iterating through the list
*
* SAMPLE CODE:
* (do-backward-chaining overworkingEnglish)
*/
(foreach ?attribute ?*LIST_OF_YN_ATTRIBUTES*
   (build (str-cat "(do-backward-chaining " ?attribute ")"))
)





(defrule mathClassBackward "rule to backward chain which math class the user is taking by asking the
                            user"
   (need-mathClass ?)
=>
   (printline "")
   (bind ?ans (lowCaseFirstChar (ask "Which math class are you taking (enter 1 for algebra 1, g for geometry, 2 for algebra 2, p for precalculus, and c for AP Calc BC)? ")))

   (while (not (or (eq ?ans "1") (eq ?ans "g") (eq ?ans "2") (eq ?ans "p") (eq ?ans "c"))) do
      (printline "")
      (printline "Please enter something that begins with 1, g, 2, p, or c.")
      (printline "")

      (bind ?ans (lowCaseFirstChar (ask "Which math class are you taking (enter 1 for Algebra 1, g for Geometry, 2 for Algebra 2, p for Honors Precalculus, and c for AP Calc BC)? ")))
   ) ; while (not (or (eq ?ans "1") (eq ?ans "g") (eq ?ans "2") (eq ?ans "p") (eq ?ans "c")))

   (assert (mathClass ?ans))
) ; defrule mathClassBackward

(defrule languageClassBackward "rule to backward chain what language level the user is taking by
                                asking the user"
   (need-languageClass ?)
=>
   (printline "")
   (bind ?ans (lowCaseFirstChar (ask "What is your language level (enter the number)? ")))

   (while (not (or (eq ?ans "1") (eq ?ans "2") (eq ?ans "3"))) do
      (printline "")
      (printline "Please enter something that begins with 1, 2, or 3.")
      (printline "")

      (bind ?ans (lowCaseFirstChar (ask "What is your language level (enter the number)? ")))
   ) ; while (not (or (eq ?ans "1") (eq ?ans "2") (eq ?ans "3")))

   (assert (languageClass ?ans))
) ; defrule languageClassBackward

(defrule areaOfInterestBackward "rule to backward chain the user's area of interest for one of
                                  their electives by asking them"
   (need-areaOfInterest ?)
=>
   (printline "")
   (bind ?ans (lowCaseFirstChar (ask "What is your area of interest for your first/second elective and not your EPO (enter a for the Study of the Arts, c for Computer Science, s for Science, h for History and Social Science, b for Business and Entrepreneurship, e for Physical Education, l for Languages, f for Fine Arts, and p for Performing Arts)? ")))

   (while (or (eq ?ans ?*prevInterest*)
              (not (or (eq ?ans "a") (eq ?ans "c") (eq ?ans "s") (eq ?ans "h") (eq ?ans "b")
              (eq ?ans "e") (eq ?ans "l") (eq ?ans "f") (eq ?ans "p")))) do
      (printline "")
      (printline "Please enter something that begins with a, c, s, h, b, e, l, f, or p.")

      (if (not (eq ?*prevInterest* "")) then
         (printline "Also, please make sure that your area of interest for this elective is different from that of the previous elective because it's better to have a diverse schedule.")
      )

      (printline "")

      (bind ?ans (lowCaseFirstChar (ask "What is your area of interest for your first/second elective and not your EPO (enter a for the Study of the Arts, c for Computer Science, s for Science, h for History and Social Science, b for Business and Entrepreneurship, e for Physical Education, l for Languages, f for Fine Arts, and p for Performing Arts)? ")))
   ) ; while (or (eq ?ans ?*prevInterest*)
     ;           (not (or (eq ?ans "a") (eq ?ans "c") (eq ?ans "s") (eq ?ans "h") (eq ?ans "b")
     ;           (eq ?ans "e") (eq ?ans "l") (eq ?ans "f") (eq ?ans "p"))))

   (assert (areaOfInterest ?ans))
) ; defrule areaOfInterestBackward

(defrule studyArtsClassBackward "rule to determine which study of the arts class the user wants to
                                 take by asking them"
   (need-studyArtsClass ?)
=>
   (printline "")
   (bind ?ans (lowCaseFirstChar (ask "Which study of arts class do you want to take (enter m for Music, t for Theater Arts, v for Visual Arts, d for Dance, and a for AP Art History)? ")))

   (while (not (or (eq ?ans "m") (eq ?ans "t") (eq ?ans "v") (eq ?ans "d") (eq ?ans "a"))) do
      (printline "")
      (printline "Please enter something that begins with m, t, v, d, or a.")
      (printline "")

      (bind ?ans (lowCaseFirstChar (ask "Which study of arts class do you want to take (enter m for Music, t for Theater Arts, v for Visual Arts, d for Dance, and a for AP Art History)? ")))
   ) ; while (not (or (eq ?ans "m") (eq ?ans "t") (eq ?ans "v") (eq ?ans "d") (eq ?ans "a")))

   (assert (studyArtsClass ?ans))
) ; defrule studyArtsClassBackward

(defrule EPO_InterestBackward "rule to determine which study of the arts class the user wants to
                                 take by asking them"
   (need-EPO_Interest ?)
=>
   (printline "")
   (bind ?ans (lowCaseFirstChar (ask "What is your area of interest for your EPO (enter d for Speech and Debate, j for Journalism, e for Business and Entrepreneurship, s for a singing group, t for a dance troupe, b for Band, o for Orchestra, p for Physical Education, and f for a Free Period)? ")))

   (while (not (or (eq ?ans "d") (eq ?ans "j") (eq ?ans "e") (eq ?ans "s") (eq ?ans "t")
                   (eq ?ans "b") (eq ?ans "o") (eq ?ans "p") (eq ?ans "f"))) do
      (printline "")
      (printline "Please enter something that begins with m, t, v, d, or a.")
      (printline "")

      (bind ?ans (lowCaseFirstChar (ask "What is your area of interest for your EPO (enter d for Speech and Debate, j for Journalism, e for Business and Entrepreneurship, s for a singing group, t for a dance troupe, b for Band, o for Orchestra, p for Physical Education, and f for a Free Period)? ")))
   ) ; while (not (or (eq ?ans "d") (eq ?ans "j") (eq ?ans "e") (eq ?ans "s") (eq ?ans "t")
     ;                (eq ?ans "b") (eq ?ans "o") (eq ?ans "p") (eq ?ans "f")))

   (assert (EPO_Interest ?ans))
) ; defrule EPO_InterestBackward





(defrule startupRule "sets up the ES"
   (declare (salience ?*STARTUP_RULE_SALIENCE*))
=>
   (printline "Welcome! Answer the following questions (answer with y for yes or n for no unless otherwise specified) to the best of your knowledge in order to determine which classes you should take at Harker for your sophomore year.")
) ; defrule startupRule

(defrule endRule "catches the instance in which the ES has run out of questions to ask"
   (declare (salience ?*END_RULE_SALIENCE*))
=>
   (printline "")
   (printline "It looks like I couldn't generate a complete course list for your sophomore year, but here's what I've generated so far:")
   (printOutCourses)

   (dishOutWarnings)

   (printline "")
   (printline "Type (runAgain) and hit enter if you want to generate another schedule.")

   (halt)
) ; defrule endRule





(defrule debate "rule to determine whether the user should take a Speech and Debate EPO"
   (EPO_Interest "d")
=>
   (addToCourseList "Speech & Debate EPO")
   (foundSchedule)
) ; defrule debate

(defrule journalism "rule to determine whether the user should take a Journalism EPO"
   (EPO_Interest "j")
=>
   (addToCourseList "Journalism EPO")
   (foundSchedule)
) ; defrule journalism

(defrule businessAndEntre "rule to determine whether the user should take a B&E EPO"
   (EPO_Interest "e")
=>
   (addToCourseList "Business and Entrepreneurship EPO")
   (foundSchedule)
) ; defrule businessAndEntre

(defrule singing "rule to determine whether the user should take a Singing EPO"
   (EPO_Interest "s")
=>
   (addToCourseList "Singing Group EPO")
   (foundSchedule)
) ; defrule singing

(defrule dance "rule to determine whether the user should take a Dance EPO"
   (EPO_Interest "t")
=>
   (addToCourseList "Dance EPO")
   (foundSchedule)
) ; defrule dance

(defrule band "rule to determine whether the user should take a Band EPO"
   (EPO_Interest "b")
=>
   (addToCourseList "Band EPO")
   (foundSchedule)
) ; defrule band

(defrule orchestra "rule to determine whether the user should take an Orchestra EPO"
   (EPO_Interest "o")
=>
   (addToCourseList "Orchestra")
   (foundSchedule)
) ; defrule orchestra

(defrule PE "rule to determine whether the user should take a PE EPO"
   (EPO_Interest "p")
=>
   (addToCourseList "PE: Personal Fitness")
   (foundSchedule)
) ; defrule PE

(defrule free "rule to determine whether the user should take a free period in their EPO slot"
   (EPO_Interest "f")
=>
   (addToCourseList "Free Period")
   (foundSchedule)
) ; defrule free





(defrule studyOfMusic1 "rule to determine whether the user should take study of music as their last
                        elective"
   (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 1))
   (studyArtsClass "m")
=>
   (addToCourseList "Study of Music")
) ; defrule studyOfMusic1

(defrule studyOfTheater1 "rule to determine whether the user should take study of theater arts as
                          their last elective"
   (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 1))
   (studyArtsClass "t")
=>
   (addToCourseList "Study of Theater Arts")
) ; defrule studyOfTheater1

(defrule studyOfVisual1 "rule to determine whether the user should take study of visual arts as
                         their last elective"
   (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 1))
   (studyArtsClass "v")
=>
   (addToCourseList "Study of Visual Arts")
) ; defrule studyOfVisual1

(defrule studyOfDance1 "rule to determine whether the user should take study of dance as their
                        last elective"
   (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 1))
   (studyArtsClass "d")
=>
   (addToCourseList "Study of Dance")
) ; defrule studyOfDance1

(defrule artHistory1 "rule to determine whether the user should take AP Art History as their
                      last elective"
   (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 1))
   (studyArtsClass "a")
=>
   (addToCourseList "AP Art History")
) ; defrule artHistory1





(defrule kinesiology1 "rule to determine whether the user should take kinesiology as their last
                       elective"
   (areaOfInterest "e")
   (test (eq ?*courseSlotsLeft* 1))
=>
   (addToCourseList "Kinesiology and Sports Medicine 1 (Semester 1), Kinesiology and Sports Medicine 2 (Semester 2)")
) ; defrule kinesiology1





(defrule econNoAPQual1 "rule to determine whether the user should take Economics and Behavioral
                        Economics as their last elective if they don't qualify for AP Econ"
   (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 1))
   (econOverEntre "y")
   (test (not (or (numberp (member$ "AP Calculus BC" ?*courseList*))
                  (numberp (member$ "Honors Multivariate Calculus (Semester 1), Honors Differential Equations (Semester 2)"
                                    ?*courseList*)))))
=>
   (addToCourseList "Economics (Semester 1), Behavioral Economics (Semester 2)")
) ; defrule econNoAPQual1

(defrule econAPQual1 "rule to determine whether the user should take Economics and Behavioral
                      Economics as their last elective if they do qualify for AP Econ"
   (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 1))
   (econOverEntre "y")
   (test (or (numberp (member$ "AP Calculus BC" ?*courseList*))
             (numberp (member$ "Honors Multivariate Calculus (Semester 1), Honors Differential Equations (Semester 2)"
                               ?*courseList*))))
   (wantsAPEcon "n")
=>
   (addToCourseList "Economics (Semester 1), Behavioral Economics (Semester 2)")
) ; defrule econAPQual1

(defrule APEcon1 "rule to determine whether the user should take AP Econ as their last elective"
   (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 1))
   (econOverEntre "y")
   (test (or (numberp (member$ "AP Calculus BC" ?*courseList*))
             (numberp (member$ "Honors Multivariate Calculus (Semester 1), Honors Differential Equations (Semester 2)"
                               ?*courseList*))))
   (wantsAPEcon "y")
=>
   (addToCourseList "AP Economics - Micro and Macro")
) ; defrule APEcon1

(defrule incubatorNoBusiness1 "rule to determine whether the user should take startup incubator I as
                               their last elective"
   (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 1))
   (econOverEntre "n")
   (startedBusiness "n")
=>
   (addToCourseList "Honors Entrepreneurship: Startup Incubator I")
) ; defrule incubatorNoBusiness1

(defrule incubatorBusiness1 "rule to determine whether the user should take startup incubator II as
                             their last elective"
   (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 1))
   (econOverEntre "n")
   (startedBusiness "y")
=>
   (addToCourseList "Honors Entrepreneurship: Startup Incubator II")
) ; defrule incubatorBusiness1





(defrule histAndSocial1 "rule to determine whether the user should take Western Political Thought
                         and World Religions as their last elective"
   (areaOfInterest "h")
   (test (eq ?*courseSlotsLeft* 1))
=>
   (addToCourseList "Western Political Thought & Philosophy (Semester 1), World Religions and Philosophy")
) ; defrule histAndSocial1





(defrule fineArts1 "rule to determine whether the user should take a fine arts elective as their
                    last elective"
   (areaOfInterest "f")
   (test (eq ?*courseSlotsLeft* 1))
=>
   (addToCourseList "2 Fine Arts Semester Electives")
) ; defrule fineArts1





(defrule performArtsNoAP1 "rule to determine whether the user should take a non-AP Performing Arts
                           elective as their last elective"
   (areaOfInterest "p")
   (test (eq ?*courseSlotsLeft* 1))
   (wantsAPMusic "n")
=>
   (addToCourseList "2 Performing Arts Semester Electives")
) ; defrule performArtsNoAP1

(defrule performArtsAP1 "rule to determine whether the user should take AP Music Theory as their
                         last elective"
   (areaOfInterest "p")
   (test (eq ?*courseSlotsLeft* 1))
   (wantsAPMusic "y")
=>
   (addToCourseList "AP Music Theory")
) ; defrule performArtsAP1





(defrule newLang1 "rule to determine whether the user should take a new language as their last
                   elective"
   (areaOfInterest "l")
   (test (eq ?*courseSlotsLeft* 1))
=>
   (addToCourseList "New Foreign Language 1")
) ; defrule newLang1





(defrule phys2NoQual1 "rule to determine whether the user should take AP Physics 2 as their last
                       elective if they don't qualify for AP Physics C"
   (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 1))
   (wantsAPPhys "y")
   (test (or (numberp (member$ "Honors Precalculus" ?*courseList*))
             (numberp (member$ "AP Calculus BC" ?*courseList*))
             (numberp (member$ "AP Calculus AB" ?*courseList*))))
   (qualPhys2 "y")
=>
   (addToCourseList "AP Physics 2")
) ; defrule phys2NoQual1

(defrule physC1 "rule to determine whether the user should take AP Physics C as their last elective"
   (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 1))
   (wantsAPPhys "y")
   (mathClass "c")
   (physicsLevel "h")
   (qualPhysC "y")
   (wantsPhysC "y")
=>
   (addToCourseList "AP Physics C")
) ; defrule physC1

(defrule phys2Qual1 "rule to determine whether the user should take AP Physics 2 as their last
                     elective if they qualify for AP Physics C"
   (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 1))
   (wantsAPPhys "y")
   (mathClass "c")
   (physicsLevel "h")
   (qualPhysC "y")
   (wantsPhysC "n")
=>
   (addToCourseList "AP Physics 2")
) ; defrule phys2Qual1

(defrule phys2NoGradeQual1 "rule to determine whether the user should take AP Physics 2 as their
                            last elective if they qualify for AP Physics C from a math perspective,
                            but they didn't receive a high enough grade in Honors Physics to do so"
   (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 1))
   (wantsAPPhys "y")
   (mathClass "c")
   (physicsLevel "h")
   (qualPhysC "n")
   (qualPhys2 "y")
=>
   (addToCourseList "AP Physics 2")
) ; defrule phys2NoGradeQual1

(defrule scienceElective1 "rule to determine whether the user should take a non-AP Science elective
                           as their last elective"
   (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 1))
   (wantsAPPhys "n")
=>
   (addToCourseList "Science Elective(s)")
) ; defrule scienceElective1





(defrule preAPCS_Qual1 "rule to determine whether the user should take a pre-AP CS course as their
                        last elective if they qualify to take it"
   (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 1))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "2") (eq ?m "p") (eq ?m "c")))
   (wantsAPCS "n")
=>
   (addToCourseList "2 Pre-AP Computer Science Semester Electives")
) ; defrule preAPCS_Qual1

(defrule preAPCS_NoQual1 "rule to determine whether the user should take a pre-AP CS course as their
                          last elective if they don't qualify to take it"
   (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 1))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "1") (eq ?m "g")))
=>
   (addToCourseList "2 Pre-AP Computer Science Semester Electives")
) ; defrule preAPCS_NoQual1

(defrule APCS_A1 "rule to determine whether the user should take APCS A as their last elective"
   (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 1))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "2") (eq ?m "p") (eq ?m "c")))
   (wantsAPCS "y")
   (wantsCSDS "n")
=>
   (addToCourseList "AP Computer Science A")
) ; defrule APCS_A1

(defrule APCS_DS1 "rule to determine whether the user should take APCS DS as their last elective"
   (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 1))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "2") (eq ?m "p") (eq ?m "c")))
   (wantsAPCS "y")
   (wantsCSDS "y")
=>
   (addToCourseList "AP Computer Science A with Data Structures")
) ; defrule APCS_DS1

(defrule DS_ATCS1 "rule to determine whether the user should take DS and an ATCS as their last
                   electives"
   (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 1))
   (completedAPCS "y")
   (completedCSDS "n")
=>
   (addToCourseList "Honors Data Structures (Semester 1), Honors Advanced Topics in Computer Science (Semester 2)")
) ; defrule DS_ATCS1

(defrule ATCS1 "rule to determine whether the user should take two ATCS courses as their last
                electives"
   (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 1))
   (completedAPCS "y")
   (completedCSDS "y")
=>
   (addToCourseList "Honors Advanced Topics in Computer Science (2 different one-semester courses)")
) ; defrule ATCS1





(defrule resetAreaOfInterest "rule to reset areaOfInterest if none of the other elective rules
                              fired"
   (declare (salience ?*AREA_OF_INTEREST_RESET_SALIENCE*))
   ?f <- (areaOfInterest ?a)
   (test (eq ?*courseSlotsLeft* 2))
=>
   (retractAndAssignPrevInterest ?f)
)





(defrule studyOfMusic2 "rule to determine whether the user should take study of music as their first
                        elective"
   ?f <- (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 2))
   (studyArtsClass "m")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Study of Music")
) ; defrule studyOfMusic2

(defrule studyOfTheater2 "rule to determine whether the user should take study of theater arts as
                          their first elective"
   ?f <- (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 2))
   (studyArtsClass "t")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Study of Theater Arts")
) ; defrule studyOfTheater2

(defrule studyOfVisual2 "rule to determine whether the user should take study of visual arts as
                         their first elective"
   ?f <- (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 2))
   (studyArtsClass "v")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Study of Visual Arts")
) ; defrule studyOfVisual2

(defrule studyOfDance2 "rule to determine whether the user should take study of dance as their
                        first elective"
   ?f <- (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 2))
   (studyArtsClass "d")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Study of Dance")
) ; defrule studyOfDance2

(defrule artHistory2 "rule to determine whether the user should take AP Art History as their
                      first elective"
   ?f <- (areaOfInterest "a")
   (test (eq ?*courseSlotsLeft* 2))
   (studyArtsClass "a")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Art History")
) ; defrule artHistory2





(defrule kinesiology2 "rule to determine whether the user should take kinesiology as their first
                       elective"
   ?f <- (areaOfInterest "e")
   (test (eq ?*courseSlotsLeft* 2))
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Kinesiology and Sports Medicine 1 (Semester 1), Kinesiology and Sports Medicine 2 (Semester 2)")
) ; defrule kinesiology2





(defrule econNoAPQual2 "rule to determine whether the user should take Economics and Behavioral
                        Economics as their first elective if they don't qualify for AP Econ"
   ?f <- (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 2))
   (econOverEntre "y")
   (test (not (or (numberp (member$ "AP Calculus BC" ?*courseList*))
                  (numberp (member$ "Honors Multivariate Calculus (Semester 1), Honors Differential Equations (Semester 2)"
                                    ?*courseList*)))))
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Economics (Semester 1), Behavioral Economics (Semester 2)")
) ; defrule econNoAPQual2

(defrule econAPQual2 "rule to determine whether the user should take Economics and Behavioral
                      Economics as their first elective if they do qualify for AP Econ"
   ?f <- (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 2))
   (econOverEntre "y")
   (test (or (numberp (member$ "AP Calculus BC" ?*courseList*))
             (numberp (member$ "Honors Multivariate Calculus (Semester 1), Honors Differential Equations (Semester 2)"
                               ?*courseList*))))
   (wantsAPEcon "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Economics (Semester 1), Behavioral Economics (Semester 2)")
) ; defrule econAPQual2

(defrule APEcon2 "rule to determine whether the user should take AP Econ as their first elective"
   ?f <- (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 2))
   (econOverEntre "y")
   (test (or (numberp (member$ "AP Calculus BC" ?*courseList*))
             (numberp (member$ "Honors Multivariate Calculus (Semester 1), Honors Differential Equations (Semester 2)"
                               ?*courseList*))))
   (wantsAPEcon "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Economics - Micro and Macro")
) ; defrule APEcon2

(defrule incubatorNoBusiness2 "rule to determine whether the user should take startup incubator I as
                               their first elective"
   ?f <- (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 2))
   (econOverEntre "n")
   (startedBusiness "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Honors Entrepreneurship: Startup Incubator I")
) ; defrule incubatorNoBusiness2

(defrule incubatorBusiness2 "rule to determine whether the user should take startup incubator II as
                             their first elective"
   ?f <- (areaOfInterest "b")
   (test (eq ?*courseSlotsLeft* 2))
   (econOverEntre "n")
   (startedBusiness "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Honors Entrepreneurship: Startup Incubator II")
) ; defrule incubatorBusiness2





(defrule histAndSocial2 "rule to determine whether the user should take Western Political Thought
                         and World Religions as their first elective"
   ?f <- (areaOfInterest "h")
   (test (eq ?*courseSlotsLeft* 2))
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Western Political Thought & Philosophy (Semester 1), World Religions and Philosophy")
) ; defrule histAndSocial2





(defrule fineArts2 "rule to determine whether the user should take a fine arts elective as their
                    first elective"
   ?f <- (areaOfInterest "f")
   (test (eq ?*courseSlotsLeft* 2))
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "2 Fine Arts Semester Electives")
) ; defrule fineArts2





(defrule performArtsNoAP2 "rule to determine whether the user should take a non-AP Performing Arts
                           elective as their first elective"
   ?f <- (areaOfInterest "p")
   (test (eq ?*courseSlotsLeft* 2))
   (wantsAPMusic "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "2 Performing Arts Semester Electives")
) ; defrule performArtsNoAP2

(defrule performArtsAP2 "rule to determine whether the user should take AP Music Theory as their
                         first elective"
   ?f <- (areaOfInterest "p")
   (test (eq ?*courseSlotsLeft* 2))
   (wantsAPMusic "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Music Theory")
) ; defrule performArtsAP2





(defrule newLang2 "rule to determine whether the user should take a new language as their first
                   elective"
   ?f <- (areaOfInterest "l")
   (test (eq ?*courseSlotsLeft* 2))
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Foreign Language 1")
) ; defrule newLang2





(defrule phys2NoQual2 "rule to determine whether the user should take AP Physics 2 as their first
                       elective if they don't qualify for AP Physics C"
   ?f <- (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 2))
   (wantsAPPhys "y")
   (test (or (numberp (member$ "Honors Precalculus" ?*courseList*))
             (numberp (member$ "AP Calculus BC" ?*courseList*))
             (numberp (member$ "AP Calculus AB" ?*courseList*))))
   (qualPhys2 "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Physics 2")
) ; defrule phys2NoQual2

(defrule physC2 "rule to determine whether the user should take AP Physics C as their first
                 elective"
   ?f <- (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 2))
   (wantsAPPhys "y")
   (mathClass "c")
   (physicsLevel "h")
   (qualPhysC "y")
   (wantsPhysC "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Physics C")
) ; defrule physC2

(defrule phys2Qual2 "rule to determine whether the user should take AP Physics 2 as their first
                     elective if they qualify for AP Physics C"
   ?f <- (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 2))
   (wantsAPPhys "y")
   (mathClass "c")
   (physicsLevel "h")
   (qualPhysC "y")
   (wantsPhysC "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Physics 2")
) ; defrule phys2Qual2

(defrule phys2NoGradeQual2 "rule to determine whether the user should take AP Physics 2 as their
                            first elective if they qualify for AP Physics C from a math perspective,
                            but they didn't receive a high enough grade in Honors Physics to do so"
   ?f <- (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 2))
   (wantsAPPhys "y")
   (mathClass "c")
   (physicsLevel "h")
   (qualPhysC "n")
   (qualPhys2 "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Physics 2")
) ; defrule phys2NoGradeQual2

(defrule scienceElective2 "rule to determine whether the user should take a non-AP Science elective
                           as their first elective"
   ?f <- (areaOfInterest "s")
   (test (eq ?*courseSlotsLeft* 2))
   (wantsAPPhys "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Science Elective(s)")
) ; defrule scienceElective2





(defrule preAPCS_Qual2 "rule to determine whether the user should take a pre-AP CS course as their
                        first elective if they qualify to take it"
   ?f <- (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 2))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "2") (eq ?m "p") (eq ?m "c")))
   (wantsAPCS "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "2 Pre-AP Computer Science Semester Electives")
) ; defrule preAPCS_Qual2

(defrule preAPCS_NoQual2 "rule to determine whether the user should take a pre-AP CS course as their
                          first elective if they don't qualify to take it"
   ?f <- (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 2))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "1") (eq ?m "g")))
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "2 Pre-AP Computer Science Semester Electives")
) ; defrule preAPCS_NoQual2

(defrule APCS_A2 "rule to determine whether the user should take APCS A as their first elective"
   ?f <- (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 2))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "2") (eq ?m "p") (eq ?m "c")))
   (wantsAPCS "y")
   (wantsCSDS "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Computer Science A")
) ; defrule APCS_A2

(defrule APCS_DS2 "rule to determine whether the user should take APCS DS as their first elective"
   ?f <- (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 2))
   (completedAPCS "n")
   (mathClass ?m)
   (test (or (eq ?m "2") (eq ?m "p") (eq ?m "c")))
   (wantsAPCS "y")
   (wantsCSDS "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "AP Computer Science A with Data Structures")
) ; defrule APCS_DS2

(defrule DS_ATCS2 "rule to determine whether the user should take DS and an ATCS as their first
                   electives"
   ?f <- (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 2))
   (completedAPCS "y")
   (completedCSDS "n")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Honors Data Structures (Semester 1), Honors Advanced Topics in Computer Science (Semester 2)")
) ; defrule DS_ATCS2

(defrule ATCS2 "rule to determine whether the user should take two ATCS courses as their first
                electives"
   ?f <- (areaOfInterest "c")
   (test (eq ?*courseSlotsLeft* 2))
   (completedAPCS "y")
   (completedCSDS "y")
=>
   (retractAndAssignPrevInterest ?f)
   (addToCourseList "Honors Advanced Topics in Computer Science (2 different one-semester courses)")
) ; defrule ATCS2





(defrule takeAPLanguage "rule to determine whether the user should take the AP class in their
                         foreign language"
   (languageClass "3")
   (continueLanguage "y")
   (languageLevel "h")
   (overworkingLanguage "n")
   (canDoAPLanguage "y")
   (wantsAPLanguage "y")
=>
   (addToCourseList "AP Foreign Language")
) ; defrule takeAPLanguage

(defrule stayHonorsLang4CannotAP "rule to determine whether the user should stay in honors language
                                  and take level 4 if they can't take AP Language"
   (languageClass "3")
   (continueLanguage "y")
   (languageLevel "h")
   (overworkingLanguage "n")
   (canDoAPLanguage "n")
=>
   (addToCourseList "Honors Foreign Language 4")
) ; defrule stayHonorsLang4CannotAP

(defrule stayHonorsLang4NoWantAP "rule to determine whether the user should stay in honors language
                                  and take level 4 if they don't want to take the AP course but can"
   (languageClass "3")
   (continueLanguage "y")
   (languageLevel "h")
   (overworkingLanguage "n")
   (canDoAPLanguage "y")
   (wantsAPLanguage "n")
=>
   (addToCourseList "Honors Foreign Language 4")
) ; defrule stayHonorsLang4NoWantAP

(defrule moveDownLang4 "rule to determine whether the user should move down to regular language and
                        take level 4"
   (languageClass "3")
   (continueLanguage "y")
   (languageLevel "h")
   (overworkingLanguage "y")
=>
   (addToCourseList "Foreign Language 4")
) ; defrule moveDownLang4

(defrule stayRegLang4NoMoveUp "rule to determine whether the user should stay in regular language
                               and take level 4 if they don't want to move up"
   (languageClass "3")
   (continueLanguage "y")
   (languageLevel "r")
   (overworkingLanguage "n")
   (moveUpLanguage "n")
=>
   (addToCourseList "Foreign Language 4")
) ; defrule stayRegLang4NoMoveUp

(defrule stayRegLang4Overworking "rule to determine whether the user should stay in regular language
                                  and take level 4 if they are overworking"
   (languageClass "3")
   (continueLanguage "y")
   (languageLevel "r")
   (overworkingLanguage "y")
=>
   (addToCourseList "Foreign Language 4")
) ; defrule stayRegLang4Overworking

(defrule moveUpLang4 "rule to determine whether the user should move up to honors language and take
                      level 4"
   (languageClass "3")
   (continueLanguage "y")
   (languageLevel "r")
   (overworkingLanguage "n")
   (moveUpLanguage "y")
=>
   (addToCourseList "Honors Foreign Language 4")
) ; defrule moveUpLang4





(defrule stayHonorsLang3 "rule to determine whether the user should stay in honors language and
                          take level 3"
   (languageClass "2")
   (languageLevel "h")
   (overworkingLanguage "n")
=>
   (addToCourseList "Honors Foreign Language 3")
) ; defrule stayHonorsLang3

(defrule moveDownLang3 "rule to determine whether the user should move down to regular language and
                        take level 3"
   (languageClass "2")
   (languageLevel "h")
   (overworkingLanguage "y")
=>
   (addToCourseList "Foreign Language 3")
) ; defrule moveDownLang3

(defrule stayRegLang3NoMoveUp "rule to determine whether the user should stay in regular language
                               and take level 3 if they don't want to move up"
   (languageClass "2")
   (languageLevel "r")
   (overworkingLanguage "n")
   (moveUpLanguage "n")
=>
   (addToCourseList "Foreign Language 3")
) ; defrule stayRegLang3NoMoveUp

(defrule stayRegLang3Overworking "rule to determine whether the user should stay in regular language
                                  and take level 3 if they are overworking"
   (languageClass "2")
   (languageLevel "r")
   (overworkingLanguage "y")
=>
   (addToCourseList "Foreign Language 3")
) ; defrule stayRegLang3Overworking

(defrule moveUpLang3 "rule to determine whether the user should move up to honors language and take
                      level 3"
   (languageClass "2")
   (languageLevel "r")
   (overworkingLanguage "n")
   (moveUpLanguage "y")
=>
   (addToCourseList "Honors Foreign Language 3")
) ; defrule moveUpLang3





(defrule regLang2 "rule to determine whether the user should take level 2 if they aren't taking
                   Spanish because only Spanish has an Honors level 2 class"
   (languageClass "1")
   (takingSpanish "n")
=>
   (addToCourseList "Foreign Language 2")
) ; defrule regLang2

(defrule stayRegLang2NoMoveUp "rule to determine whether the user should stay in regular language
                               and take level 2 if they don't want to move up"
   (languageClass "1")
   (takingSpanish "y")
   (overworkingLanguage "n")
   (moveUpLanguage "n")
=>
   (addToCourseList "Spanish 2")
) ; defrule stayRegLang2NoMoveUp

(defrule stayRegLang2Overworking "rule to determine whether the user should stay in regular language
                                  and take level 2 if they are overworking"
   (languageClass "1")
   (takingSpanish "y")
   (overworkingLanguage "y")
=>
   (addToCourseList "Spanish 2")
) ; defrule stayRegLang2Overworking

(defrule moveUpLang2 "rule to determine whether the user should move up to honors language and take
                      level 2"
   (languageClass "1")
   (takingSpanish "y")
   (overworkingLanguage "n")
   (moveUpLanguage "y")
=>
   (addToCourseList "Honors Spanish 2")
) ; defrule moveUpLang2





(defrule takeAPChem "rule to determine whether the user should take AP Chemistry"
   (physicsLevel "h")
   (overworkingPhysics "n")
   (canDoAPChem "y")
   (wantsAPChem "y")
=>
   (addToCourseList "AP Chemistry")
) ; defrule takeAPChem

(defrule stayHonorsChemQual "rule to determine whether the user should stay in honors science if
                             they qualify for AP Chem"
   (physicsLevel "h")
   (overworkingPhysics "n")
   (canDoAPChem "y")
   (wantsAPChem "n")
=>
   (addToCourseList "Honors Chemistry")
) ; defrule stayHonorsChemQual

(defrule stayHonorsChemNoQual "rule to determine whether the user should stay in honors science if
                               they don't qualify for AP Chem"
   (physicsLevel "h")
   (overworkingPhysics "n")
   (canDoAPChem "n")
=>
   (addToCourseList "Honors Chemistry")
) ; defrule stayHonorsChemNoQual

(defrule moveDownChem "rule to determine whether the user should move down to regular science"
   (physicsLevel "h")
   (overworkingPhysics "y")
=>
   (addToCourseList "Chemistry")
) ; defrule moveDownChem

(defrule stayRegChemNoMoveUp "rule to determine whether the user should stay in regular science if
                              they don't want to move up"
   (physicsLevel "r")
   (overworkingPhysics "n")
   (moveUpPhysics "n")
=>
   (addToCourseList "Chemistry")
) ; defrule stayRegChemNoMoveUp

(defrule stayRegChemOverworking "rule to determine whether the user should stay in regular science
                                 if they are overworking"
   (physicsLevel "r")
   (overworkingPhysics "y")
=>
   (addToCourseList "Chemistry")
) ; defrule stayRegChemOverworking

(defrule moveUpChem "rule to determine whether the user should move up to honors science"
   (physicsLevel "r")
   (overworkingPhysics "n")
   (moveUpPhysics "y")
=>
   (addToCourseList "Honors Chemistry")
) ; defrule moveUpChem





(defrule takeATMath "rule to determine whether the user should take AT Math"
   (mathClass "c")
=>
   (addToCourseList "Honors Multivariate Calculus (Semester 1), Honors Differential Equations (Semester 2)")
) ; defrule takeATMath





(defrule takeCalcBC "rule to determine whether the user should take AP Calculus BC"
   (mathClass "p")
   (overworkingMath "n")
=>
   (addToCourseList "AP Calculus BC")
) ; defrule takeCalcBC

(defrule takeCalcAB "rule to determine whether the user should take AP Calculus AB"
   (mathClass "p")
   (overworkingMath "y")
=>
   (addToCourseList "AP Calculus AB")
) ; defrule takeCalcAB





(defrule stayHonorsPreCalc "rule to determine whether the user should stay in honors math and take
                            precalculus"
   (mathClass "2")
   (mathLevel "h")
   (overworkingMath "n")
=>
   (addToCourseList "Honors Precalculus")
) ; defrule stayHonorsPreCalc

(defrule moveDownPreCalc "rule to determine whether the user should move down to regular math and
                          take precalculus"
   (mathClass "2")
   (mathLevel "h")
   (overworkingMath "y")
=>
   (addToCourseList "Precalculus")
) ; defrule moveDownPreCalc

(defrule stayRegPreCalcNoMoveUp "rule to determine whether the user should stay in regular math and
                                 take precalculus if they don't want to move up"
   (mathClass "2")
   (mathLevel "r")
   (overworkingMath "n")
   (moveUpMath "n")
=>
   (addToCourseList "Precalculus")
) ; defrule stayRegPreCalcNoMoveUp

(defrule stayRegPreCalcOverworking "rule to determine whether the user should stay in regular math
                                    and take precalculus if they are overworking"
   (mathClass "2")
   (mathLevel "r")
   (overworkingMath "y")
=>
   (addToCourseList "Precalculus")
) ; defrule stayRegPreCalcOverworking

(defrule moveUpPreCalc "rule to determine whether the user should move up to honors math and take
                        precalculus"
   (mathClass "2")
   (mathLevel "r")
   (overworkingMath "n")
   (moveUpMath "y")
=>
   (addToCourseList "Honors Precalculus")
) ; defrule moveUpPreCalc





(defrule stayHonorsAlg2 "rule to determine whether the user should stay in honors math and take
                         algebra 2"
   (mathClass "g")
   (mathLevel "h")
   (overworkingMath "n")
=>
   (addToCourseList "Honors Algebra 2/Trig")
) ; defrule stayHonorsAlg2

(defrule moveDownAlg2 "rule to determine whether the user should move down to regular math and take
                       algebra 2"
   (mathClass "g")
   (mathLevel "h")
   (overworkingMath "y")
=>
   (addToCourseList "Algebra 2/Trig")
) ; defrule moveDownAlg2

(defrule stayRegAlg2NoMoveUp "rule to determine whether the user should stay in regular math and
                              take algebra 2 if they don't want to move up"
   (mathClass "g")
   (mathLevel "r")
   (overworkingMath "n")
   (moveUpMath "n")
=>
   (addToCourseList "Algebra 2/Trig")
) ; defrule stayRegAlg2NoMoveUp

(defrule stayRegAlg2Overworking "rule to determine whether the user should stay in regular math and
                                 take algebra 2 if they are overworking"
   (mathClass "g")
   (mathLevel "r")
   (overworkingMath "y")
=>
   (addToCourseList "Algebra 2/Trig")
) ; defrule stayRegAlg2Overworking

(defrule moveUpAlg2 "rule to determine whether the user should move up to honors math and take
                     algebra 2"
   (mathClass "g")
   (mathLevel "r")
   (overworkingMath "n")
   (moveUpMath "y")
=>
   (addToCourseList "Honors Algebra 2/Trig")
) ; defrule moveUpAlg2





(defrule stayHonorsGeo "rule to determine whether the user should stay in honors math and take
                        geometry"
   (mathClass "1")
   (mathLevel "h")
   (overworkingMath "n")
=>
   (addToCourseList "Honors Geometry")
) ; defrule stayHonorsGeo

(defrule moveDownGeo "rule to determine whether the user should move down to regular math and take
                      geometry"
   (mathClass "1")
   (mathLevel "h")
   (overworkingMath "y")
=>
   (addToCourseList "Geometry")
) ; defrule moveDownGeo

(defrule stayRegGeoNoMoveUp "rule to determine whether the user should stay in regular math and take
                             geometry if they don't want to move up"
   (mathClass "1")
   (mathLevel "r")
   (overworkingMath "n")
   (moveUpMath "n")
=>
   (addToCourseList "Geometry")
) ; defrule stayRegGeoNoMoveUp

(defrule stayRegGeoOverworking "rule to determine whether the user should stay in regular math and
                                take geometry if they are overworking"
   (mathClass "1")
   (mathLevel "r")
   (overworkingMath "y")
=>
   (addToCourseList "Geometry")
) ; defrule stayRegGeoOverworking

(defrule moveUpGeo "rule to determine whether the user should move up to honors math and take
                    geometry"
   (mathClass "1")
   (mathLevel "r")
   (overworkingMath "n")
   (moveUpMath "y")
=>
   (addToCourseList "Honors Geometry")
) ; defrule moveUpGeo





(defrule takeEuro "rule to determine whether the user should take AP Euro"
   (historyLevel "h")
   (overworkingHistory "n")
   (wantsAPHistory "y")
   (wantsEuro "y")
=>
   (addToCourseList "AP European History")
) ; defrule takeEuro

(defrule takeWAP "rule to determine whether the user should take AP World"
   (historyLevel "h")
   (overworkingHistory "n")
   (wantsAPHistory "y")
   (wantsEuro "n")
=>
   (addToCourseList "AP World History")
) ; defrule takeWAP

(defrule stayHonorsHistory "rule to determine whether the user should stay in honors history"
   (historyLevel "h")
   (overworkingHistory "n")
   (wantsAPHistory "n")
=>
   (addToCourseList "Honors World History 2")
) ; defrule stayHonorsHistory

(defrule stayRegHistoryNoMoveUp "rule to determine whether the user should stay in regular history
                                 if they don't want to move up"
   (historyLevel "r")
   (overworkingHistory "n")
   (moveUpHistory "n")
=>
   (addToCourseList "World History 2")
) ; defrule stayRegHistoryNoMoveUp

(defrule stayRegHistoryOverworking "rule to determine whether the user should stay in regular
                                    history if they are overworking"
   (historyLevel "r")
   (overworkingHistory "y")
=>
   (addToCourseList "World History 2")
) ; defrule stayRegHistoryOverworking

(defrule moveDownHistory "rule to determine whether the user should move down to regular history"
   (historyLevel "h")
   (overworkingHistory "y")
=>
   (addToCourseList "World History 2")
) ; defrule moveDownHistory

(defrule moveUpHistory "rule to determine whether the user should move up to honors history"
   (historyLevel "r")
   (overworkingHistory "n")
   (moveUpHistory "y")
=>
   (addToCourseList "Honors World History 2")
) ; defrule moveUpHistory





(defrule stayHonorsEnglish "rule to determine whether the user should stay in honors english if
                            they are currently in honors english"
   (englishLevel "h")
   (overworkingEnglish "n")
=>
   (addToCourseList "Honors English 2")
) ; defrule stayHonorsEnglish

(defrule moveDownEnglish "rule to determine whether the user should move down to regular english"
   (englishLevel "h")
   (overworkingEnglish "y")
=>
   (addToCourseList "English 2: A Survey of British Literature")
) ; defrule moveDownEnglish

(defrule stayRegEnglishNoMoveUp "rule to determine whether the user should stay in regular
                                 english if they don't want to move up"
   (englishLevel "r")
   (overworkingEnglish "n")
   (moveUpEnglish "n")
=>
   (addToCourseList "English 2: A Survey of British Literature")
) ; defrule stayRegEnglishNoMoveUp

(defrule stayRegEnglishOverworking "rule to determine whether the user should stay in regular
                                    english if they are overworking"
   (englishLevel "r")
   (overworkingEnglish "y")
=>
   (addToCourseList "English 2: A Survey of British Literature")
) ; defrule stayRegEnglishOverworking

(defrule moveUpEnglish "rule to determine whether the user should move up to honors english"
   (englishLevel "r")
   (overworkingEnglish "n")
   (moveUpEnglish "y")
=>
   (addToCourseList "Honors English 2")
) ; defrule moveUpEnglish

/*
* dynamically creates all of the backward chaining rules for the attributes in LIST_OF_YN_ATTRIBUTES
* by iterating through LIST_OF_YN_ATTRIBUTES and LIST_OF_YN_QUESTIONS and creating the corresponding
* backward-chaining rule at every iteration
*
* SAMPLE CODE:
* (defrule overworkingEnglishBackward
*    (need-overworkingEnglish ?)
* =>
*    (printline "")
*    (bind ?ans (lowCaseFirstChar (ask "Do you spend more time working on English than you would like to? ")))
*    (if (or (eq ?ans "y") (eq ?ans "n")) then
*       (assert (overworkingEnglish ?ans))
*     else
*        (assert (overworkingEnglish (chastiseTheUserForYesNoQuestions "Do you spend more time working on English than you would like to? ")))
*    )
* )
*/
(for (bind ?i 1) (<= ?i (length$ ?*LIST_OF_YN_ATTRIBUTES*)) (++ ?i)
   (bind ?currentAttribute (nth$ ?i ?*LIST_OF_YN_ATTRIBUTES*)) ; the current attribute for which the
                                                               ; backward chaining rule will be
                                                               ; created
   (bind ?currentQuestion (nth$ ?i ?*LIST_OF_YN_QUESTIONS*))   ; the corresponding question to ask
                                                               ; the user

   /*
   * begins setting up ruleString with the defrule command and the name of the rule to be created
   */
   (bind ?ruleString (str-cat "(defrule " ?currentAttribute "Backward "))

   /*
   * sets up the LHS of the rule by adding the need indicator
   */
   (bind ?ruleString (str-cat ?ruleString "(need-" ?currentAttribute " ?) => "))

   /*
   * sets up the RHS of the rule, the main purpose of which is to ask the user a question and assert
   * the user's answer
   */
   (bind ?ruleString (str-cat ?ruleString
                              "(printline \"\")
                               (bind ?ans (lowCaseFirstChar (ask \""?currentQuestion "\")))
                               (if (or (eq ?ans \"y\") (eq ?ans \"n\")) then
                                  (assert (" ?currentAttribute " ?ans))
                                else
                                   (assert (" ?currentAttribute " (chastiseTheUserForYesNoQuestions \"" ?currentQuestion "\")))
                               ))"))
   (build ?ruleString)
) ; for (bind ?i 1) (<= ?i (length$ ?*LIST_OF_YN_ATTRIBUTES*)) (++ ?i)

/*
* dynamically creates all of the backward chaining rules for the attributes in LIST_OF_HR_ATTRIBUTES
* by iterating through LIST_OF_HR_ATTRIBUTES and LIST_OF_HR_QUESTIONS and creating the corresponding
* backward-chaining rule at every iteration
*
* SAMPLE CODE:
* (defrule englishLevelBackward
*    (need-englishLevel ?)
* =>
*    (printline "")
*    (bind ?ans (lowCaseFirstChar (ask "What is your english level (enter h for honors or r for regular)? ")))
*    (if (or (eq ?ans "h") (eq ?ans "r")) then
*       (assert (englishLevel ?ans))
*     else
*        (assert (englishLevel (chastiseTheUserForHRQuestions "What is your english level (enter h for honors or r for regular)? ")))
*    )
* )
*/
(for (bind ?i 1) (<= ?i (length$ ?*LIST_OF_HR_ATTRIBUTES*)) (++ ?i)
   (bind ?currentAttribute (nth$ ?i ?*LIST_OF_HR_ATTRIBUTES*)) ; the current attribute for which the
                                                               ; backward chaining rule will be
                                                               ; created
   (bind ?currentQuestion (nth$ ?i ?*LIST_OF_HR_QUESTIONS*))   ; the corresponding question to ask
                                                               ; the user

   /*
   * begins setting up ruleString with the defrule command and the name of the rule to be created
   */
   (bind ?ruleString (str-cat "(defrule " ?currentAttribute "Backward "))

   /*
   * sets up the LHS of the rule by adding the need indicator
   */
   (bind ?ruleString (str-cat ?ruleString "(need-" ?currentAttribute " ?) => "))

   /*
   * sets up the RHS of the rule, the main purpose of which is to ask the user a question and assert
   * the user's answer
   */
   (bind ?ruleString (str-cat ?ruleString
                              "(printline \"\")
                               (bind ?ans (lowCaseFirstChar (ask \""?currentQuestion "\")))
                               (if (or (eq ?ans \"h\") (eq ?ans \"r\")) then
                                  (assert (" ?currentAttribute " ?ans))
                                else
                                   (assert (" ?currentAttribute " (chastiseTheUserForHRQuestions \"" ?currentQuestion "\")))
                               ))"))
   (build ?ruleString)
) ; for (bind ?i 1) (<= ?i (length$ ?*LIST_OF_HR_ATTRIBUTES*)) (++ ?i)

/*
* warns the user about overloading their sophomore year with APs
*/
(deffunction dishOutWarnings ()
   (bind ?numOfAPs 0)

   (foreach ?course ?*courseList*
      (bind ?c (sub-string 1 (str-length "AP") ?course))

      (if (eq ?c "AP") then
         (++ ?numOfAPs)
      )
   ) ; foreach ?course ?*courseList*

   (if (> ?numOfAPs ?*MANAGEABLE_NUM_OF_APS*) then
      (printline (str-cat "WARNING: You are taking " ?numOfAPs
                          " APs, and that number of difficult classes may not be manageable."))
   )

   (return)
) ; deffunction dishOutWarnings ()

/*
* ends the ES processing if the ES has found a potential schedule for the user
*/
(deffunction foundSchedule ()
   (if (eq ?*courseSlotsLeft* -1) then
      (printline "")
      (printline "Here's the schedule I've generated for your sophomore year at Harker:")
      (printOutCourses)

      (dishOutWarnings)

      (printline "")
      (printline "Type (runAgain) and hit enter if you want to generate another schedule.")

      (halt)
   ) ; if (eq ?*courseSlotsLeft* -1) then

   (return)
) ; deffunction foundSchedule ()

/*
* scolds the user for not entering h or r and continues to re-ask the question until the user enters
* a valid answer
*
* returns the user's valid answer
*/
(deffunction chastiseTheUserForHRQuestions (?questionToAsk)
   (printline "")
   (printline "Please enter something that begins with h or r.")
   (printline "")

   (bind ?ans (lowCaseFirstChar (ask ?questionToAsk)))

   (while (not (or (eq ?ans "h") (eq ?ans "r"))) do
      (printline "")
      (printline "Please enter something that begins with h or r.")
      (printline "")

      (bind ?ans (lowCaseFirstChar (ask ?questionToAsk)))
   ) ; while (not (or (eq ?ans "h") (eq ?ans "r")))

   (return ?ans)
) ; deffunction chastiseTheUserForHRQuestions (?questionToAsk)

/*
* adds the specified class to the end of courseList and decrements courseSlotsLeft
*/
(deffunction addToCourseList (?str)
   (-- ?*courseSlotsLeft*)

   (bind ?index (+ (length$ ?*courseList*) 1))
   (bind ?*courseList* (replace$ ?*courseList* ?index ?index ?str))

   (return)
) ; deffunction addToCourseList (?str)

/*
* prints out the list of courses that the ES has determined the user should take
*/
(deffunction printOutCourses ()
   (foreach ?course ?*courseList*
      (printline ?course)
   )

   (return)
) ; deffunction printOutCourses ()

/*
* retracts the inputted fact and binds prevInterest to the 1st slot value of it
*
* this should be called only on the RHS of the elective rules that trigger when there are 2 course
* slots left because this method allows the next set of elective rules to re-backward chain
* the attribute areaOfInterest
*/
(deffunction retractAndAssignPrevInterest (?f)
   (retract ?f)
   (bind ?*prevInterest* (nth$ 1 (fact-slot-value ?f "__data")))

   (return)
) ; deffunction retractAndAssignPrevInterest (?f)

(runAgain) ; begins the ES


























