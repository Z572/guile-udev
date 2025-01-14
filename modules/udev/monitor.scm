(define-module (udev monitor)
  #:export (udev-monitor
	    udev-monitor?
	    %make-udev-monitor
            make-udev-monitor
	    udev-monitor-add-filter!
            udev-monitor-remove-filters!
            udev-monitor-set-timeout!
	    udev-monitor-set-callback!
            udev-monitor-set-error-callback!
	    udev-monitor-start-scanning!
	    udev-monitor-stop-scanning!
            udev-monitor-get-udev))

;; A high-level procedure that creates a new udev monitor instance with the
;; specified parameters.
(define* (make-udev-monitor udev
                            #:key
                            (callback     (const #t))
                            (error-callback (lambda (monitor error-message)
                                              (format (current-error-port)
                                                      "ERROR: in ~a: ~a~%"
                                                      monitor error-message)))
                            (filter       #f)
                            (timeout-usec 0)
                            (timeout-sec  0))
  (let ((monitor (%make-udev-monitor udev)))
    (udev-monitor-set-timeout!  monitor timeout-sec timeout-usec)
    (udev-monitor-set-callback! monitor callback)
    (udev-monitor-set-error-callback! monitor callback)
    (when filter
      (udev-monitor-add-filter! monitor (car filter) (cadr filter)))
    monitor))

(load-extension "libguile-udev" "init_udev_monitor")
