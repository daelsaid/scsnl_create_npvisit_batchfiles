@echo off
pushd "%~dp0"

::daelsaid 03142019
::------------------------

::paths to adjust below
::NP parent folder
::template folder
:: output

set parent_dir=\\171.65.52.100\NeuroPsych
set np_subj_data_path=%parent_dir%
set np_comp_address=\\171.65.52.100
::do not change below, all paths are relative to above

::user entered prompts
::numerical PID ONLY (9999)
::numerical visit number ONLY (1)
set /p pid="Enter Subject's PID only (####):"
set /p visit="Enter Subject's Visit Number (#):"
set /p project="Enter project name (met,met_asd,adhd,math_fun,asd_speech,asd_memory,asd_whiz):"
ECHO Please confirm that you have entered the correct information and the project name is entered exactly as listed

ECHO PID: %pid%
ECHO VISIT: %visit%
ECHO PROJECT: %project%
pause

set np_fldr_template_path=%parent_dir%\project_template_folders\%project%\%project%_np_template_folder

::the following folder structure represents the SCSNL PID-VISIT-ASSESSMENTS folder structure
:: set main subject folder
::set visit specific folder based off of user entered value
set main_subj_dir=%np_subj_data_path%\%pid%
set visit_dir=%main_subj_dir%\visit%visit%
set lab=%visit_dir%\assessments\lab_experiments
set sa=%lab%\strategy_assessment
set questionnaires=%lab%\questionnaire
set stand=%visit_dir%\assessments\standardized_experiments
set file_ending=%pid%_%visit%


::if visit does not equal 1, begin runinng lines at visit not initial
if "%visit%" NEQ "1" GOTO :visit_not_initial

::If PID folder already exists, skip the lines until you reach rename
:: if PID does not exist, create PID folder and copy tmeplate folder structure + scoring templates into PID
if not exist "%main_subj_dir%" ECHO PID FOLDER DOES NOT EXIST, CREATING PID FOLDER WITH TEMPLATES
md "%main_subj_dir%\visit%visit%"
xcopy %np_fldr_template_path%\visit%visit% %main_subj_dir%\visit%visit% /E
GOTO :rename_files

::assumes that the folder has been created
:visit_not_initial

if not exist "%main_subj_dir%\visit%visit%" ECHO creating visit %visit% dir
md "%main_subj_dir%\visit%visit%"
xcopy %np_fldr_template_path%\visit%visit% %np_subj_data_path%\%pid%\visit%visit% /E
GOTO :rename_files

:rename_files
:: change directories for each relevant subfolder and replaces _template suffix with PID_VISIT

ren %lab%\*_template*.* *_%file_ending%.*

ren %sa%\*_template*. *_%file_ending%.*

ren %questionnaires%\*_template*. *_%file_ending%.*

ren %stand%\*_template*. *_%file_ending%.*
:end
