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
::project name as listed in options

set /p pid="Enter Subject's PID only (####):"
set /p visit="Enter Subject's Visit Number (#):"
set /p project="Enter project name:(aml,met,asd_met,met2,prt,adhd,asd_sl,ad_sl,math_fun,asd_speech,asd_memory,asd_whiz):"

::if met entered as project, ask for appointment prompt
if "%project%"=="met" set /p appointment="Enter the neuropsych appointment's timepoint (pre,post,followup):"
if "%project%"=="asd_met" set /p appointment="Enter the neuropsych appointment's timepoint (pre,post,followup):"
if "%project%"=="met2" set /p appointment="Enter the neuropsych appointment's timepoint (pre,post,followup,followup2):"
:: asd_sl entered as project, ask for type of subject prompt
if "%project%"=="asd_sl" set /p subject_type="Enter the subject type(speaker,speaker_adult,listener):"

:: ad_sl entered as project, ask for type of subject prompt
if "%project%"=="ad_sl" set /p subject_type="Enter the subject type(speaker,listener):"

::Confirmation of PID and visit entered, if invalid script will exit
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

if "%project%"=="met" ECHO TIMEPOINT NAME: %appointment%
if "%project%"=="met2" ECHO TIMEPOINT NAME: %appointment%
if "%project%"=="asd_met" ECHO TIMEPOINT NAME: %appointment%
if "%project%"=="asd_sl" ECHO SUBJECT TYPE: %subject_type%
if "%project%"=="ad_sl" ECHO SUBJECT TYPE: %subject_type%

pause

set np_fldr_template_path=%parent_dir%\project_template_folders\%project%\%project%_np_template_folder
ECHO %np_fldr_template_path%\asd_sl_%subject_type%\visit1
::the following folder structure represents the SCSNL PID-VISIT-ASSESSMENTS folder structure
::all folders initialized for pid #
set main_subj_dir=%np_subj_data_path%\%pid%
set visit_dir=%main_subj_dir%\visit%visit%
set lab=%visit_dir%\assessments\lab_experiments
set sa=%lab%\strategy_assessment
set questionnaire=%lab%\questionnaire
set stand=%visit_dir%\assessments\standardized_experiments
set file_ending=%pid%_%visit%

::make sure pid and visit folder arent already made

if exist "%main_subj_dir%\visit%visit%" GOTO :visit_folder_exists
if not exist "%main_subj_dir%\visit%visit%" GOTO :make_folder_and_copy_templates

:make_folder_and_copy_templates

ECHO CREATING PID FOLDER FOLDER WITH TEMPLATES
md "%main_subj_dir%\visit%visit%"
::if met was entered, skip to met specific section
if "%project%"=="met" GOTO :met_project_structure
if "%project%"=="met2" GOTO :met2_project_structure
if "%project%"=="asd_met" GOTO :asd_met_project_structure
if "%project%"=="asd_sl" GOTO :asd_sl_project_structure
if "%project%"=="ad_sl" GOTO :ad_sl_project_structure


::for all studies but met, copy visit 1 folder into new PID/VISIT folder
xcopy %np_fldr_template_path%\visit1 %main_subj_dir%\visit%visit% /E
goto :rename_files

::met specfic structure
:met_project_structure
for %%a in (np1 np2 pre) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit1 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%a in (post) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit2 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%a in (followup) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit3 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)
goto :rename_files

::met2 specfic structure
:met2_project_structure
for %%a in (np1 np2 pre) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit1 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%a in (post) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit2 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%a in (followup) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit3 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%a in (followup2) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit4 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)
goto :rename_files

:asd_met_project_structure
for %%a in (np1 np2 pre) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit1 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%a in (post) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit2 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)

for %%a in (followup) do (
    if %appointment% equ %%a (
        xcopy %np_fldr_template_path%\visit3 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)
goto :rename_files

:asd_sl_project_structure
for %%a in (speaker speaker_adult listener) do (
    if %subject_type% equ %%a (
        xcopy %np_fldr_template_path%\asd_sl_%subject_type%\visit1 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)
goto :rename_files

:ad_sl_project_structure
for %%a in (speaker listener) do (
    if %subject_type% equ %%a (
        xcopy %np_fldr_template_path%\ad_sl_%subject_type%\visit1 %main_subj_dir%\visit%visit% /E
        goto :rename_files
    )
)
goto :rename_files


:rename_files
:: for each relevant subfolder and replaces _template suffix with PID_VISIT
ren %lab%\*_template*.* *_%file_ending%.*
ren %sa%\*_template*.* *_%file_ending%.*
ren %questionnaire%\*_template*.* *_%file_ending%.*
ren %stand%\*_template*.* *_%file_ending%.*
GOTO :end

:visit_folder_exists
ECHO.
ECHO THIS PARTICIPANT ALREADY HAS A VISIT %VISIT% FOLDER
ECHO check the pid folder (%pid%) to make sure that you have entered the correct visit number and project name for this participant
ECHO.
ECHO you entered: %pid% %visit% %project%
ECHO.
ECHO (PRESSING ANY KEY WILL CLOSE THE PROGRAM)
pause

:end
