@echo off

set parent_dir="C:\Users\daelsaid\Desktop\np_testing"
set main_tutoring_template_dir="%parent_dir%\np"
set np_subj_data_path="%parent_dir%\output"

set /p pid="Enter Subject's PID only (####):"
set /p tutoring_group="Enter Subject's tutoring group (spt or vnt):"

set tutoring_group_template_dir="%main_tutoring_template_dir%\tutoring_%tutoring_group%"
set main_subj_dir="%np_subj_data_path%\%pid%"
set visit_dir="%main_subj_dir%\visit1"
set lab_expir="%visit_dir%\assessments\lab_experiments"
set file_ending="%pid%_1"
set tutoring_dir="%lab_expir%\tutoring"


if exist "%tutoring_dir%" GOTO :tutoring_dir_exists

if not exist "%tutoring_dir%" ECHO CREATING TUTORING FOLDER FOR %pid%
cd %lab_expir%
md "tutoring"
xcopy %tutoring_group_template_dir% %lab_expir%\tutoring


cd %tutoring_dir%
rename "*_template.*" "*_%file_ending%.*"

:tutoring_dir_exists
ECHO TUTORING DIR EXISTS
:end
