# inspried by https://stackoverflow.com/questions/48086633/simple-logging-levels-in-bash
declare -A error_levels=([DEBUG]=0 [INFO]=1 [WARN]=2 [ERROR]=3 [FATAL]=4)
script_logging_level="DEBUG"

function log {
    local log_priority=$1
	local log_message=$2

    #check if level exists
    [[ ${error_levels[$log_priority]} ]] || return 1;
    #check if level is enough
    (( ${error_levels[$log_priority]} < ${error_levels[$script_logging_level]} )) && return 2
    #log here. Could change this to write to file?
    echo "${log_priority}: ${log_message}"
}