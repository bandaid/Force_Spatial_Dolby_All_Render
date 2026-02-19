echo Run as Administrator

schtasks /Create /TN "Force_Spatial_Dolby_All_Render" ^
  /TR "\"%USERPROFILE%\NirTools\Force_Spatial_Dolby_All_Render.cmd\"" ^
  /SC ONLOGON /RL HIGHEST /F

pause
