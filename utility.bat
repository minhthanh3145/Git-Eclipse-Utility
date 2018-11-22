REM Author: Thành, Tô - mitatoto1997@gmail.com
@echo off
setlocal enabledelayedexpansion

REM A utility file to clone Katalon repo into folder @arg1, checkout a new branch @arg2 based on branch @arg3

set argCount=0
for %%x in (%*) do (
   set /A argCount+=1
   set "argVec[!argCount!]=%%~x"
)

REM Note that if your path contains a white space, wrap the path inside a " "
set PARENT_FOLDER=a
set REFERENCE_REPO_FOLDER=b
set FOLDER_CONTAINING_BRANCHES=c
set PATH_TO_WORKSPACE=d
set PATH_TO_ECLISPE=e
set YOUR_REPO=f

if %argCount% == 3 (
	echo ------ Creating branch %1
	cd %PARENT_FOLDER%
	if NOT EXIST %FOLDER_CONTAINING_BRANCHES%\%1 (
		echo ------ %FOLDER_CONTAINING_BRANCHES%\%1 does not exist yet, cloning Katalon
		REM Note that  you can just use git clone repo directly, but cloning from a reference branch is faster
		git clone %REFERENCE_REPO_FOLDER% %FOLDER_CONTAINING_BRANCHES%\%1
	) else (
		echo ------ %FOLDER_CONTAINING_BRANCHES%\%1 already exists, opening ...
	)
	
	cd %FOLDER_CONTAINING_BRANCHES%\%1
	echo ------ Setting remote url
	git remote set-url origin %YOUR_REPO%
	echo ------ Fetching
	git fetch
	
	echo ------ Checking out base branch %3
	git checkout %3
	git pull origin %3
	git checkout %3
	
	REM Try to create a new branch, then checkout to that branch 
	echo ------ Checking out new branch %2
	git checkout -b %2
	REM this won't hurt
	git checkout %2

	REM Open folder of the new branch
	start .
	
	echo ------ Creating Eclipse workspace for %1
	cd %PATH_TO_WORKSPACE%
	if NOT EXIST %1 (
		echo ------ Eclipse workspace for \%1 does not exist yet, creating empty workspace\%1
		mkdir %1
	) else (
		echo ------ Eclipse workspace for \%1 already exists
	)
	
	cd %PATH_TO_ECLISPE%
	REM refer to https://stackoverflow.com/questions/44446216/eclipse-jdt-import-project-from-command-line
	echo ------ Importing existing projects from %PARENT_FOLDER%\%FOLDER_CONTAINING_BRANCHES%\%1\source into Eclipse workspace %1 
	eclipse -nosplash -data %PATH_TO_WORKSPACE% -application com.seeq.eclipse.importprojects.headlessimport -import %PARENT_FOLDER%\%FOLDER_CONTAINING_BRANCHES%\%1\source
	
	echo ------ Launching Eclipse with workspace %1
	eclipse -data %PATH_TO_WORKSPACE%


) else (
	echo ------ 3 arguments are necessary
	echo ------ start utility [newFolderName] [newBranchName] [baseBranch]
)
 
