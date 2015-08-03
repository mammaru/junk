(ql:quickload :ltk)

(defun hello-1 ()
  (ltk:with-ltk ()
    (let ((b (make-instance 'ltk:button
                            :master nil
                            :text "Press Me"
                            :command (lambda ()
                                       (format t "Hello World!~&")))))
      (ltk:pack b))))