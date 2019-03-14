@echo off

set parent_dir="C:\Users\daelsaid\Desktop\np_testing"
set np_fldr_template_path="%parent_dir%\np\np_template_folder"
set np_subj_data_path="%parent_dir%\output"

set /p pid="Enter Subject's PID only(####):"
set /p visit="Enter Subject's Visit Number (#):"

set main_subj_dir="%np_subj_data_path%\%pid%"
set visit_dir="%main_subj_dir%\visit%visit%"
set lab="%visit_dir%\assessments\lab_experiments"
set sa="%lab%\strategy_assessment"
set questionnaires="%lab%\questionnaire"
set stand="%visit_dir%\assessments\standardized_experiments"
set file_ending="%pid%_%visit%"

if "%visit%" NEQ "1" GOTO :visit_not_initial

if not exist "%main_subj_dir%" ECHO PID FOLDER DOES NOT EXIST, CREATING PID FOLDER WITH TEMPLATES
md "%main_subj_dir%"
xcopy %np_fldr_template_path% %np_subj_data_path%\%pid% /E
GOTO :rename_files

:visit_not_initial
ECHO PID FOLDER EXISTS, RENAMING VISIT 2 TEMPLATES
GOTO :rename_files

:rename_files
cd %lab%
rename "*_template.*" "*_%file_ending%.*"

cd %sa%
rename "*_template.*" "*_%file_ending%.*"

cd %questionnaires%
rename "*_template.*" "*_%file_ending%.*"

cd %stand%
rename "*_template.*" "*_%file_ending%.*"
:end
