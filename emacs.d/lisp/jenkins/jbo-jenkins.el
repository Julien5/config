(if (file-exists-p "~/.ssh/github-work/jbo-jenkins.el")
	(progn
	  (add-to-list 'load-path "~/.emacs.d/lisp/jenkins/jenkins.el-master")
	  (require 'jenkins)
	  (load "~/.ssh/github-work/jbo-jenkins.el")
	  )
  )
