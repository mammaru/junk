(defun mappend1 (fn the-list)
  (if (null the-list)
	  nil
	  (append (funcall fn (first the-list))
			  (mappend fn (rest the-list)))))
(defun mappend2 (fn the-list)
  (apply #'append (mapcar fn the-list)))


(defun one-of (set)
  (list (random-elt set)))

(defun random-elt (choices)
  (elt choices (random (length choices))))

(defun sentence ()
  (append (noun-phrase) (verb-phrase)))
(defun noun-phrase ()
  (append (Article) (Noun)))
(defun verb-phrase ()
  (append (Verb) (noun-phrase)))
(defun Article ()
  (one-of '(a the)))
(defun Noun ()
  (one-of '(man ball woman table)))
(defun Verb ()
  (one-of '(hit took saw liked)))

(defparameter *simple-grammar*
  '((sentence -> (noun-phrase verb-phrase))
	(noun-phrase -> (Article Noun))
	(verb-phrase -> (Verb noun-phrase))
	(Article -> a the)
	(Noun -> man ball woman table)
	(Verb -> hit took saw liked))
  "A grammar for a trivial subset of English")

(defvar *grammar* *simple-grammar*)

(defun rule-lhs (rule)
  (first rule))
(defun rule-rhs (rule)
  (rest (rest rule)))
(defun rewrites (category)
  (rule-rhs (assoc category *grammar*)))

(defun generate (phrase)
  (cond ((listp phrase)
		 (mappend2 #'generate phrase))
		((rewrites phrase)
		 (generate (random-elt (rewrites phrase))))
		(t (list phrase))))
