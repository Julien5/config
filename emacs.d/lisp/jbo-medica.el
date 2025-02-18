(defun jbo--mingw49-path-fixup ()
  (setenv "PATH"
		  (concat
		   "c:/tools/old/Qt5.6.3/5.6.3/mingw49_32/bin" ";"
		   "c:/tools/old/Qt5.6.3/Tools/mingw492_32/bin" ";"
		   "c:/home/jbourgeois/setup/make/win32" ";"
		   (getenv "PATH")
		   )
		  )
  )

(defun jbo--mingw73-path-fixup ()
  (setenv "PATH"
		  (concat
		   "c:/tools/Qt/5.12.10/mingw73_32/bin" ";"
		   "c:/tools/Qt/Tools/mingw730_32/bin" ";"
		   "c:/home/jbourgeois/setup/make/win32" ";"
		   (getenv "PATH")
		   )
		  )
  )

(defun jbo-dev-mingw49 ()
  (jbo--mingw49-path-fixup)
  (setenv "PROJECTSDIR" "c:/home/jbourgeois/work/projects")
  (setenv "THIRDPARTYDIR" "c:/home/jbourgeois/work/3rdparty")
  (setenv "TARGET_ARCH" "x86")
  )

(defun jbo-dev-mingw73 ()
  (jbo--mingw73-path-fixup)
  (setenv "PROJECTSDIR" "c:/home/jbourgeois/work/projects")
  (setenv "THIRDPARTYDIR" "c:/home/jbourgeois/work/3rdparty")
  (setenv "TARGET_ARCH" "x86")
  )

(defun jbo-env-from-dev (dev)
  (setq fmt0 "source ~/setup/profile/profile.sh &> /dev/null; %s &> /dev/null; printenv -0")
  (let ((cmd (format fmt0 dev)))
	(shell-command-to-string cmd)
	)
  )

(defun jbo-dev-desktop ()
  (let ((ENV (jbo-env-from-dev "dev.desktop")))
	(setenv "SETUPROOT" (jbo-read-env ENV "SETUPROOT"))
	(setenv "PROJECTSDIR" (jbo-read-env ENV "PROJECTSDIR"))
	(setenv "THIRDPARTYDIR" (jbo-read-env ENV "THIRDPARTYDIR"))
	(setenv "PATH" (jbo-read-env ENV "PATH"))
	(setenv "CMAKE_GENERATOR" (jbo-read-env ENV "CMAKE_GENERATOR"))
	)
  )
