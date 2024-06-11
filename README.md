# System Parameter Monitoring Script

This Bash script monitors and logs various system parameters. The script creates a report with the current date and time and saves it to a log file.

## Contents

- [Installation](#installation)
- [Usage](#usage)
- [Functions](#functions)
- [File Output](#file-output)
- [License](#license)

## Installation

1. **Save the script file:**

   Save the script in a directory of your choice. Example:
   ```bash
   /usr/local/bin/systemreport/systemreport.sh
   ```

2. **Make the script executable:**
   ```bash
   chmod +x /usr/local/bin/systemreport/systemreport.sh
   ```

3. **Create directory for log files:**
   ```bash
   mkdir -p /usr/local/bin/systemreport
   ```

## Usage

- Run the script with the following command:

   ```bash
   /usr/local/bin/systemreport/systemreport.sh
   ```

## Functions

### Retrieve Date and Time

- The script retrieves the current date and time and stores them in variables.

### Disk Space Monitoring

- Checks the disk space usage and logs this information.

### Web Services Monitoring

- Checks the status of the web services:
  - `ascserver`
  - `ascserver_reifenman`
- Logs whether they are active or inactive.

### Log Files Monitoring

- Checks the number and size of log files in the directory `/var/log/asc`.
- Lists the three largest files.

## File Output

```
########################################
###                                  ###
###             CAPTEST              ###
###                -                 ###
###            06.06.2024            ###
###              14:30               ###
###                                  ###
########################################

         DISK SPACE USAGE:

       Size | Used | Avail | Use%
        50G |  10G |  40G  | 20%

########################################

              WEBSERVICES:

 ascserver............................OK
 ---------------------------------------
 ascserver_reifenman...............!DOWN!

########################################

               LOGFILES:

 capsit.log......................2 Files
  - 1.1M | Jun  6 10:20 | capsit.log
  - 1.0M | Jun  6 09:15 | capsit.log
    ...
 ---------------------------------------
 pl6565..........................5 Files
  - 500K | Jun  6 11:30 | pl6565
  - 480K | Jun  6 11:00 | pl6565
    ...

########################################
```

## License

- This script is licensed under the MIT License. For more information, see the [LICENSE](./LICENSE) file.
