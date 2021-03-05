Config = {}

Config.MeetingPerm = 'jd.meeting'                                           -- This permission is needed to start/stop a meeting.
Config.AcePerm = 'jd.staff'                                                 -- This permission is needed to bypass player restrictions.


Config.SpawnPoint = 404.86, -964.78, -99.00                                 -- Spawn point for meeting start
Config.Zone = {                                                             -- Zone Players need to be in
    {409.12, -967.77, -99.00},
    {409.12, -961.99, -99.00},
    {400.95, -961.99, -99.00},
    {400.95, -967.77, -99.00},
}


Config.Logs = false                                                         -- Set to true to enable Logs (https://github.com/JokeDevil/JD_logs)
Config.LogsChannel = "meeting"
Config.LogsColor = "#000000"

Config.versionCheck = "1.0.0"