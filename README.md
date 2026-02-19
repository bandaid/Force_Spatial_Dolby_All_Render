# Force Spatial Dolby All Render

Enforce **Dolby Atmos** as **Spatial sound** at **logon** for Windows render (playback) endpoints.

> [!IMPORTANT]
> This repo is only for setting Spatial sound to Dolby Atmos on startup. Nothing else.
> 
> If you do not own a Dolby Atmos license, this will not work.
>
> If you do not have Dolby Atmos installed, this will not work.

---

## Table of contents
1. [Overview](#overview)
2. [Requirements](#requirements)
3. [Install](#install)
4. [Usage](#usage)
5. [Scripts](#scripts)
   1. [Force_Spatial_Dolby_All_Render.cmd](#force_spatial_dolby_all_rendercmd)
   2. [TaskCreate_Spatial_Dolby_All_Render.cmd](#taskcreate_spatial_dolby_all_rendercmd)
   3. [Verify_Spatial_Render_Enabled.cmd](#verify_spatial_render_enabledcmd)
6. [Logs](#logs)
7. [Remove the scheduled task](#remove-the-scheduled-task)
8. [Troubleshooting](#troubleshooting)
9. [Screenshots](#screenshots)

---

## Overview

Windows may revert Spatial sound to **Off** or **Windows Sonic** after reboot. These scripts re-apply **Dolby Atmos** automatically at logon.

✅ What it does:
1. Applies Dolby Atmos to default render roles:
   1. `DefaultRenderDevice`
   2. `DefaultRenderDeviceMulti`
   3. `DefaultRenderDeviceComm`
2. Applies Dolby Atmos to all render endpoints via wildcard target:
   1. `*\Render`
3. Writes a log with per-target OK or FAIL lines.

🚫 What it does not do:
1. No volume changes.
2. No EQ or enhancements.
3. No device switching logic beyond default roles.
4. No redistribution of NirSoft tools.

---

## Requirements

### 1. Windows
1. Windows

### 2. NirSoft tool download (not included)
Place the NirSoft tool here:
- `%USERPROFILE%\NirTools\SoundVolumeView.exe`

Optional console tool:
- `%USERPROFILE%\NirTools\svcl.exe`

Download links:
```text
https://www.nirsoft.net/utils/sound_volume_view.html
https://www.nirsoft.net/utils/sound_volume_command_line.html
````

> [!NOTE]
> If Dolby Atmos is not available for an endpoint, that endpoint may log FAIL. The script can only set formats that Windows exposes.

---

## Install

1. Create folder:

   * `%USERPROFILE%\NirTools\`

2. Copy NirSoft tool(s) into:

   * `%USERPROFILE%\NirTools\`

3. Copy these CMD files into the same folder:

   1. `Force_Spatial_Dolby_All_Render.cmd`
   2. `TaskCreate_Spatial_Dolby_All_Render.cmd`
   3. `Verify_Spatial_Render_Enabled.cmd`

4. Optional: create log folder (scripts also create it automatically):

   * `%USERPROFILE%\NirTools\Log\`

---

## Usage

### 1. Manual run

Run:

```bat
"%USERPROFILE%\NirTools\Force_Spatial_Dolby_All_Render.cmd"
```

### 2. Create logon task

Run as Administrator:

```bat
"%USERPROFILE%\NirTools\TaskCreate_Spatial_Dolby_All_Render.cmd"
```

### 3. Verify after logon

Run:

```bat
"%USERPROFILE%\NirTools\Verify_Spatial_Render_Enabled.cmd"
```

> [!TIP]
> First-time setup: run Manual run once, confirm the log shows OK lines, then create the scheduled task.

---

## Scripts

### Force_Spatial_Dolby_All_Render.cmd

Purpose:

1. Enforce Dolby Atmos Spatial sound at logon.

Actions:

1. Waits a startup delay so Windows audio is initialized.
2. Applies Dolby Atmos to:

   1. `DefaultRenderDevice`
   2. `DefaultRenderDeviceMulti`
   3. `DefaultRenderDeviceComm`
   4. `*\Render`

Outputs:

1. Log file:

   * `%USERPROFILE%\NirTools\Log\Force_Spatial_Dolby_All_Render.log`

Success indicators:

1. Log contains `OK` lines for targets.
2. Log ends with `INFO Done`.

---

### TaskCreate_Spatial_Dolby_All_Render.cmd

Purpose:

1. Create a Scheduled Task that runs the force script at logon.

Creates:

1. Task name:

   * `Force_Spatial_Dolby_All_Render`
2. Task action:

   * Runs `%USERPROFILE%\NirTools\Force_Spatial_Dolby_All_Render.cmd`

---

### Verify_Spatial_Render_Enabled.cmd

Purpose:

1. Confirm the expected Dolby Atmos Spatial sound is currently applied to render endpoints.

Outputs:

1. Console summary.
2. Optional verification log (depends on your implementation).

---

## Logs

Primary log location:

* `%USERPROFILE%\NirTools\Log\`

Primary log file:

* `%USERPROFILE%\NirTools\Log\Force_Spatial_Dolby_All_Render.log`

Recommended workflow:

1. Run force script.
2. Open the log.
3. Confirm `OK` entries exist for the targets you care about.

---

## Remove the scheduled task

Delete the task (run as Administrator):

```bat
schtasks /Delete /TN "Force_Spatial_Dolby_All_Render" /F
```

Confirm removal:

```bat
schtasks /Query /TN "Force_Spatial_Dolby_All_Render"
```

> [!WARNING]
> If you change the task name inside TaskCreate_Spatial_Dolby_All_Render.cmd, update the delete command to match.

---

## Troubleshooting

### 1. Log shows OK but the Windows UI looks wrong

1. Close and reopen the Sound settings page.
2. Some UI panes cache state until reopened.

### 2. FAIL entries for some endpoints

1. Not all endpoints support Dolby Atmos as a Spatial option.
2. HDMI, Bluetooth, and virtual endpoints can behave differently.

### 3. Nothing happens at logon

1. Confirm the task exists:

```bat
schtasks /Query /TN "Force_Spatial_Dolby_All_Render" /V /FO LIST
```

2. Confirm the force log timestamp updates at logon:

   * `%USERPROFILE%\NirTools\Log\Force_Spatial_Dolby_All_Render.log`

### 4. Dolby applies sometimes, but not always

1. Increase the startup delay inside `Force_Spatial_Dolby_All_Render.cmd`.
2. Some audio endpoints initialize late.

---

Optional:

1. Windows Spatial sound dropdown:

   * `docs/images/windows_spatial_dropdown.png`
2. Task Scheduler task details:

   * `docs/images/task_scheduler_force_spatial.png`

</details>
