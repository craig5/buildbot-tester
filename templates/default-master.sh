MASTER_RUNNER={{MASTER_RUNNER}}

# NOTE: MASTER_ENABLED has changed its behaviour in version 0.8.4. Use
# 'true|yes|1' to enable instance and 'false|no|0' to disable. Other
# values will be considered as syntax error.

MASTER_ENABLED[1]=1                    # 1-enabled, 0-disabled
MASTER_NAME[1]="buildmaster #1"        # short name printed on start/stop
MASTER_USER[1]="{{USER}}"              # user to run master as
MASTER_BASEDIR[1]="{{MASTER_DIR}}"     # basedir to master (absolute path)
MASTER_OPTIONS[1]=""                   # buildbot options
MASTER_PREFIXCMD[1]=""                 # prefix command, i.e. nice, linux32, dchroot
