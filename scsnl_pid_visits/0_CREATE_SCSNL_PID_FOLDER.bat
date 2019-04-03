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
set /p project="Enter project name:(met,met_asd,adhd,math_fun,asd_speech,asd_memory,asd_whiz):"

if "%project%"=="met" set /p appointment="Enter the neuropsych appointment's timepoint (pre,post,followup):"
ECHO.
set /p pid2="ENTER PID AGAIN TO CONTINUE (PIDS MUST MATCH OR PROGRAM WILL EXIT):"
set /p visit2="ENTER VISIT # AGAIN TO CONTINUE (VISITS MUST MATCH OR PROGRAM WILL EXIT):"
ECHO.


if "%pid%" NEQ "%pid2%" GOTO :pid_visit_invalid
if "%visit%" NEQ "%visit2%" GOTO :pid_visit_invalid
if "%pid%"=="%pid2%" GOTO :continue
if "%visit%"=="%visit2%" GOTO :continue

:pid_visit_invalid

if "%pid%" NEQ "%pid2%" ECHO YOU ENTERED 2 DIFFERENT PIDS: %pid% and %pid2%, RESTART THE PROGRAM AND ENTER THE CORRECT PID
if "%visit%" NEQ "%visit2%" ECHO YOU ENTERED 2 DIFFERENT VISIT NUMBERS: VISIT %visit% and %visit2%, RESTART THE PROGRAM AND ENTER THE CORRECT VISIT NUMBER
ECHO (PRESSING ANY KEY WILL CLOSE THE PROGRAM)
pause
GOTO :end

:continue
ECHO Please confirm that you have entered the correct information and the project name is entered exactly as listed below

ECHO PID: %pid%
ECHO VISIT: %visit%
ECHO PROJECT: %project%
if "%project%"=="met" ECHO APPOINTMENT NAME: %appointment%
pause

set np_fldr_template_path=%parent_dir%\project_template_folders\%project%\%project%_np_template_folder

::the following folder structure represents the SCSNL PID-VISIT-ASSESSMENTS folder structure
::set main subject folder
::set visit specific folder based off of user entered value

set main_subj_dir=%np_subj_data_path%\%pid%
set visit_dir=%main_subj_dir%\visit%visit%
set lab=%visit_dir%\assessments\lab_experiments
set sa=%lab%\strategy_assessment
set questionnaire=%lab%\questionnaire
set stand=%visit_dir%\assessments\standardized_experiments
set file_ending=%pid%_%visit%

if not exist "%main_subj_dir%\visit%visit%" ECHO CREATING PID FOLDER FOLDER WITH TEMPLATES
md "%main_subj_dir%\visit%visit%"

if %project%=="met" GOTO :met_project_structure

xcopy %np_fldr_template_path%\visit1 %main_subj_dir%\visit%visit% /E
goto :rename_files

::if visit does not equal 1, begin runinng lines at visit not initial

:met_project_structure
for %%apt in (np1 np2 pre) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit1 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%apt in (post) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit2 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%apt in (followup) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit3 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)
goto :rename_files

::If PID folder already exists, skip the lines until you reach rename
:: if PID does not exist, create PID folder and copy tmeplate folder structure + scoring templates into PID

:rename_files
:: change directories for each relevant subfolder and replaces _template suffix with PID_VISIT
ren %lab%\*_template*.* *_%file_ending%.*
ren %sa%\*_template*.* *_%file_ending%.*
ren %questionnaire%\*_template*.* *_%file_ending%.*
ren %stand%\*_template*.* *_%file_ending%.*
:end
