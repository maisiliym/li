(use-modules (uniks krimyn)
	     (maisiliym)
	     (ice-9 textual-ports)
	     )

(define krimyn
  (make <krimyn>
    #:neim "li"
    #:spici "kodyr"
    #:trost 2
    #:saiz 2
    #:prikriom prikriom
    #:github "maisiliym"))

(define prikriom
  (make <prikriom>
    #:ful (get-string-all "./xerxes.asc")
    #:ssh "AAAAC3NzaC1lZDI1NTE5AAAAIEygb1Ft1hIB+ExPGLq08im9rFYvOeYXX+NetgqjI3Db"
    #:keygrip "AD305831DD33E62F9AD587718D4E5E6999CD84EA"))
