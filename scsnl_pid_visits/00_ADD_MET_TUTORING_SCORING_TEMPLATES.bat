@echo off
pushd "%~dp0"

::daelsaid 04032019
::------------------------

set parent_dir=\\171.65.52.100\NeuroPsych
set np_subj_data_path=%parent_dir%

::do not change below, all paths are relative to above
::user entered prompts
::numerical PID ONLY (9999)
::numerical visit number ONLY (1)

set /p pid="Enter Subject's PID only (####):"
set /p tutoring_group="Enter Subject's tutoring group (spt or vnt):"
set /p visit="Enter the Visit Number (#) that the tutoring folder created in:"

::Confirmation of PID and visit entered, if invalid script will exit
ECHO.
set /p pid2="ENTER PID AGAIN TO CONTINUE (PIDS MUST MATCH OR PROGRAM WILL EXIT):"
set /p tutoring_group2="ENTER TUTORING INTERVENTION (INTERVENTION MUST MATCH PROGRAM WILL EXIT):"
set /p visit2="ENTER VISIT # AGAIN TO CONTINUE (VISITS MUST MATCH OR PROGRAM WILL EXIT):"
ECHO.

if "%pid%" NEQ "%pid2%" GOTO :pid_visit_invalid
if "%visit%" NEQ "%visit2%" GOTO :pid_visit_invalid
if "%tutoring_group%" NEQ "%tutoring_group2%" GOTO :pid_visit_invalid

if "%pid%"=="%pid2%" GOTO :continue
if "%visit%"=="%visit2%" GOTO :continue
if "%tutoring_group%"=="%tutoring_group2%" GOTO :continue

:pid_visit_invalid

if "%pid%" NEQ "%pid2%" ECHO YOU ENTERED 2 DIFFERENT PIDS: %pid% and %pid2%, RESTART THE PROGRAM AND ENTER THE CORRECT PID
if "%visit%" NEQ "%visit2%" ECHO YOU ENTERED 2 DIFFERENT VISIT NUMBERS: VISIT %visit% and %visit2%, RESTART THE PROGRAM AND ENTER THE CORRECT VISIT NUMBER
If "%tutoring_group%" NEQ "%tutoring_group2%" ECHO YOU ENTERED 2 DIFFERENT INTERVENTIONS: TUTORING GROUP: %tutoring_group% and %tutoring_group2%, RESTART THE PROGRAM AND ENTER THE CORRECT INTERVENTION
ECHO (PRESSING ANY KEY WILL CLOSE THE PROGRAM)
pause
GOTO :end

:continue
ECHO Please confirm that you have entered the correct information and the project name is entered exactly as listed below

ECHO PID: %pid%
ECHO TUTORING GROUP: %tutoring_group%
ECHO VISIT: %visit%
pause

set main_tutoring_template_dir=%parent_dir%\project_template_folders\met\tutoring_%tutoring_group%
set main_subj_dir=%np_subj_data_path%\%pid%
set visit_dir=%main_subj_dir%\visit%visit%
set lab=%visit_dir%\assessments\lab_experiments
set tutoring_dir=%lab%\tutoring
set file_ending=%pid%_%visit%

::make sure pid and visit folder arent already made
if exist "%tutoring_dir%" GOTO :tutoring_folder_exists
if not exist "%tutoring_dir%" GOTO :make_folder_and_copy_templates

:make_folder_and_copy_templates

ECHO CREATING TUTORING FOLDER FOLDER WITH TEMPLATES
md "%tutoring_dir%"
xcopy %main_tutoring_template_dir% %lab%\tutoring /E
goto :rename_files

:rename_files
:: for each relevant subfolder and replaces _template suffix with PID_VISIT
ren %tutoring_dir%\*_template*.* *_%file_ending%.*
GOTO :end

:tutoring_folder_exists
ECHO.
ECHO THIS PARTICIPANT ALREADY HAS A TUTORING FOLDER IN %pid%'s VISIT %VISIT% FOLDER
ECHO Check the pid folder (%pid%) to make sure that you want have entered the correct visit number and project name for this participant.
ECHO  Make sure you entered the correct visit number to create the tutoring folder.
ECHO.
ECHO you entered: %pid% %tutoring_group% %visit%
ECHO.
ECHO (PRESSING ANY KEY WILL CLOSE THE PROGRAM)
pause
:end
