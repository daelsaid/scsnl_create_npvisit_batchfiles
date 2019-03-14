@echo off

:: daelsaid 03142019
::------------------------

::script assumes MET visit structure
::PID_VISIT suffix to replace template in scoring files set to visit 1
::------------------------

::paths to adjust below
::NP parent folder
::Folder with tutoring templates
::output
set parent_dir="C:\Users\daelsaid\Desktop\np_testing"
set main_tutoring_template_dir="%parent_dir%\np"
set np_subj_data_path="%parent_dir%\output"

::do not change below, all paths are relative to above
::user entered prompts
set /p pid="Enter Subject's PID only (####):"
set /p tutoring_group="Enter Subject's tutoring group (spt or vnt):"

ECHO Please confirm that you have entered the correct information

ECHO PID: %pid%
ECHO Tutoring Group: %tutoring_group%
pause

 ::tutoring specific template folder
set tutoring_group_template_dir="%main_tutoring_template_dir%\tutoring_%tutoring_group%"
set main_subj_dir="%np_subj_data_path%\%pid%"
set visit_dir="%main_subj_dir%\visit1"
set lab_expir="%visit_dir%\assessments\lab_experiments"
set tutoring_dir="%lab_expir%\tutoring"
set file_ending="%pid%_1"

:: if tutoring folder already exists, skip commands and end
if exist "%tutoring_dir%" GOTO :tutoring_dir_exists

::check if a tutoring does not exist and make tutoring folder in PID/visit1/assessments/lab_experiments
::copy group specific templates into PID/visit1/assessments/lab_experiments/tutoring

if not exist "%tutoring_dir%" ECHO CREATING TUTORING FOLDER FOR %pid%
cd %lab_expir%
md "tutoring"
xcopy %tutoring_group_template_dir% %lab_expir%\tutoring
cd %tutoring_dir%
::replace template suffix with PID_VISIT file ending
rename "*_template.*" "*_%file_ending%.*"

:tutoring_dir_exists
ECHO TUTORING DIR ALREADY EXISTS
:end
